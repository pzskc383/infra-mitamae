# Knot DNS cookbook

module KnotHelpers
  def dns_serial
    now = Time.now
    midnight = Time.new(now.year, now.month, now.day, 0, 0, 0)
    part = ((now.to_i - midnight.to_i) * 99 / 86_400)
    Kernel.format("%s%02d", now.strftime("%Y%m%d"), part)
  end
end

MItamae::RecipeContext.include(KnotHelpers)

# Install packages
%w[knot dbus ldns-utils].each do |pkg|
  openbsd_package pkg do
    action :install
  end
end

# Zone directory
directory '/var/db/knot/zones' do
  mode '0750'
  owner '_knot'
  group 'wheel'
end

# Log directory
directory '/var/log/knot' do
  mode '0755'
  owner '_knot'
  group '_knot'
end

# Knot configuration
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

# Zone files (primary only)
node[:knot_zones].each_key do |zone_name|
  next unless node[:knot_zones][zone_name][:primary] == node[:hocho_host]

  template "/var/db/knot/zones/#{zone_name}.zone" do
    source "templates/zones/#{zone_name}.zone.erb"
    mode '0644'
    owner '_knot'
    group 'wheel'
    variables(hosts: node[:hosts])
    notifies :reload, 'service[knot]'
  end
end

# Enable and start service
service 'knot' do
  action %i[enable start]
end

# Register PF snippet for DNS redirect
node[:pf_snippets] ||= []
node[:pf_snippets] << <<~PF
  # dns redirect to knot on non-standard port
  pass in proto { udp tcp } to port domain rdr-to 127.0.0.1 port 17053
  pass in proto { udp tcp } to port domain rdr-to ::1 port 17053
PF
