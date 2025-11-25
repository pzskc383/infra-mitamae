# Knot DNS cookbook
node.reverse_merge!({
  knot_localhost_port: 17_053,
  knot_zones: [],
  knot_zone_snippets: [],
  knot_dnssec: []
})

node.validate! do
  {
    knot_dns_serial: optional(integer),
    knot_localhost_port: integer,
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

local_ruby_block "knot_set_dns_serial" do
  block do
    now = Time.now
    midnight = Time.new(now.year, now.month, now.day, 0, 0, 0)
    part = ((now.to_i - midnight.to_i) * 99 / 86_400)
    serial = Kernel.format("%s%02d", "#{now.year}#{now.month}#{now.day}", part)

    node.reverse_merge!({ knot_dns_serial: serial })
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
  variables(
    knot_zones: node[:knot_zones],
    knot_tsig_secret: node[:knot_tsig_secret],
    hosts: node[:hosts],
    current_host: node[:hocho_host]
  )
  notifies :restart, 'service[knot]'
end

local_ruby_block "rerender_zones" do
  action :nothing
end

define :zone_snippet, content: nil do
  node[:knot_zone_snippets] << {
    zone: params[:name],
    content: params[:content]
  }

  notify!("local_ruby_block[rerender_zones]") { action :run }
end

node[:knot_zones].each do |z|
  next unless z[:primary] == node[:hocho_host]

  template "/var/db/knot/zones/#{z[:name]}.zone" do
    source "templates/zones/#{z[:name]}.zone.erb"
    mode '0640'
    owner '_knot'
    group 'wheel'

    variables(hosts: node[:hosts])

    notifies :reload, 'service[knot]'
    subscribes :create, 'local_ruby_block[rerender_zones]'
  end
end

node[:knot_dnssec].each do |z|
  zone_snippet z[:name] do
    content "@ IN #{z[:ksk][:dnskey]}"
  end
end

service 'knot' do
  action %i[enable start]
end

pf_snippet 'knot' do
  content <<~PF
    # dns redirect to knot on non-standard port
    pass in proto { udp tcp } to port domain rdr-to 127.0.0.1 port #{node[:knot_localhost_port]}
    pass in proto { udp tcp } to port domain rdr-to ::1 port #{node[:knot_localhost_port]}
  PF
end
