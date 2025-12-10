# Knot DNS cookbook
node.reverse_merge!({
  knot_zones: [],
  knot_zone_snippets: [],
  knot_dnssec: []
})

node.validate! do
  {
    knot_zone_snippets: array_of({
      zone: string,
      content: array_of(string)
    }),
    knot_zones: array_of({
      name: string,
      primary: string,
      secondaries: array_of(string)
    }),
    knot_dnssec: array_of({
      zone: string,
      ksk: {
        priv: string
      }
    })
  }
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
  variables(
    knot_zones: node[:knot_zones],
    knot_tsig_secret: node[:knot_tsig_secret],
    hosts: node[:hosts],
    current_host: node[:hostname]
  )
  notifies :restart, 'service[knot]'
end

local_zones = []
node[:knot_zones].each do |z|
  now = Time.now
  midnight = Time.new(now.year, now.month, now.day, 0, 0, 0)
  part = ((now.to_i - midnight.to_i) * 99 / 86_400)
  serial = Kernel.format("%s%02d", "#{now.year}#{now.month}#{now.day}", part)
  next unless z[:primary] == node[:hostname]

  zone = z[:name]
  local_zones << zone

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

    notifies :reload, 'service[knot]'
  end
end

key_import_dir = "/var/db/knot/keys-import"

define :knot_domain_ksk, ksk: nil do
  zone = params[:zone]
  keyname = format("K%s.+013+%05d", zone, params[:ksk][:keytag])

  local_ruby_block "keymgr import #{zone}" do
    not_if "keymgr #{zone} list |grep ZSK"
    block do
      directory key_import_dir
      file "#{key_import_dir}/#{keyname}.private" do
        content params[:ksk][:priv]
        sensitive true
        group "_knot"
        mode "0640"
      end

      file "#{key_import_dir}/#{keyname}.key" do
        content "#{zone}. IN #{params[:ksk][:dnskey]}"
        group "_knot"
        mode "0640"
      end

      command "keymgr #{zone} import-bind #{key_import_dir}/#{keyname.shellescape}.private"

      %w[private key].each do |ext|
        file "#{key_import_dir}/#{keyname}.#{ext}" do
          action :delete
        end
      end
    end
  end
end

node[:knot_dnssec].each do |dnskey|
  zone = dnskey[:zone]
  next unless local_zones.include? zone

  knot_domain_ksk dnskey[:zone] do
    ksk dnskey[:ksk]
  end

  execute "keymgr cleanup #{zone}" do
    # remove all but first key of each type
    command <<~CMD
      keymgr #{zone} list|grep -F KSK|sed 1d |awk '{print $1}'|xargs -n1 keymgr #{zone} delete
      keymgr #{zone} list|grep -F ZSK|sed 1d |awk '{print $1}'|xargs -n1 keymgr #{zone} delete
    CMD
    only_if "test $(keymgr #{zone} list |wc -l) -gt 2"
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

service 'knot' do
  action %i[enable start]
end

pf_snippet 'knot' do
  content <<~PF
    pass in proto { udp tcp } to port domain set queue dns
  PF
end