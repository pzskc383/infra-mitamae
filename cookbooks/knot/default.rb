# Knot DNS cookbook
node.reverse_merge!({
  knot_zones: [],
  knot_dnssec: []
})

key_import_dir = "/var/db/knot/keys-import"

define :knot_domain_ksk, ksk: nil do
  zone = params[:name]
  keyname = format("K%s.+013+%05d", zone, params[:ksk][:keytag])

  needs_import = run_command("keymgr #{zone} list |grep -qF KSK", error: false).exit_status > 0
  directory key_import_dir do
    only_if { needs_import }
  end

  file "#{key_import_dir}/#{keyname}.private" do
    only_if { needs_import }
    content params[:ksk][:priv]
    sensitive true
    group "_knot"
    mode "0640"
  end

  file "#{key_import_dir}/#{keyname}.key" do
    only_if { needs_import }
    content "#{zone}. IN #{params[:ksk][:dnskey]}"
    group "_knot"
    mode "0640"
  end

  execute "keymgr #{zone} import-bind #{key_import_dir}/#{keyname.shellescape}.private" do
    only_if { needs_import }
  end

  %w[private key].each do |ext|
    file "#{key_import_dir}/#{keyname}.#{ext}" do
      action :delete
      only_if { needs_import }
    end
  end
end

%w[knot dbus ldns-utils].each do |pkg|
  openbsd_package pkg do
    action :install
  end
end

directory '/var/db/knot/zones' do
  mode '0750'
  owner '_knot'
  group 'wheel'
end

directory '/var/log/knot' do
  mode '0755'
  owner '_knot'
  group '_knot'
end

template '/etc/knot/knot.conf' do
  source 'templates/knot.conf.erb'
  mode '0644'
  owner 'root'
  group 'wheel'
  other_hosts = node[:hosts].reject { |k,v| k == node[:hostname] }
  variables(
    knot_zones: node[:knot_zones],
    knot_tsig_secret: node[:knot_tsig_secret],
    hosts: other_hosts,
    current_host: node[:hostname]
  )
  notifies :restart, 'service[knot]'
end

service 'knot' do
  action %i[enable start]
end

node[:knot_zones].each do |z|
  now = Time.now
  midnight = Time.new(now.year, now.month, now.day, 0, 0, 0)
  part = ((now.to_i - midnight.to_i) * 99 / 86_400)
  serial = Kernel.format("%s%02d", "#{now.year}#{now.month}#{now.day}", part)
  next unless z[:primary] == node[:hostname]

  zone = z[:name]
  dnskey = node[:knot_dnssec].reject {|d| d[:zone] != zone }.first

  template "#{z[:name]}.zone" do
    source "templates/zones/#{z[:name]}.zone.erb"
    path "/var/db/knot/zones/#{z[:name]}.zone"

    mode '0640'
    owner '_knot'
    group 'wheel'

    variables(
      hosts: node[:hosts],
      serial: serial
    )

  end

  execute "reload #{zone}" do
    command <<-EOC
      knotc zone-check #{zone} && \
      knotc zone-reload #{zone}
    EOC
  end

  knot_domain_ksk dnskey[:zone] do
    ksk dnskey[:ksk]
  end

  %w[KSK ZSK].each do |keytype|
    execute "keymgr cleanup #{keytype} in #{zone}" do
      # remove all but first key of each type
      command <<~CMD
        keymgr #{zone} list| \
        grep -F #{keytype}| \
        sed 1d | \
        awk '{print $1}'| \
        xargs -n1 keymgr #{zone} delete
      CMD
      only_if "test $(keymgr #{zone} list | grep #{keytype} | wc -l) -gt 1"
    end
  end

  execute "keymgr generate zsk for #{zone}" do
    command "keymgr #{zone} generate ksk=no zsk=yes"
    not_if "keymgr #{zone} list |grep ZSK"
  end
end

directory key_import_dir do
  action :delete
  only_if "test -d #{key_import_dir}"
end

pf_snippet 'knot' do
  content <<~PF
    pass in proto { udp tcp } to port domain set queue dns
  PF
end
