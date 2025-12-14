node[:newsyslog_extra_lines] = []

include_recipe "defines.rb"

openbsd_package "vim" do
  action :install
  flavor "no_x11"
end

%w[
  /etc/daily.local /etc/weekly.local
  /etc/syslog.conf /etc/ntpd.conf
  /var/unbound/etc/unbound.conf
].each do |fn|
  remote_file fn do
    source "files/#{File.basename(fn)}"
    mode "0640"
  end
end

template "/etc/newsyslog.conf" do
  source "templates/newsyslog.conf.erb"
  mode "0640"
end

file "/etc/resolv.conf" do
  mode "0644"
end

if node[:network_setup][:v6][:use_slaac]
  service "slaacd" do
    action %i[enable start]
  end
end
if node[:network_setup][:v4][:use_dhcp]
  service "dhcpleased" do
    action %i[enable start]
  end
end

execute "netstart" do
  action :nothing
  command "/bin/sh /etc/netstart"
end

%w[mygate hostname.vio0].each do |netfile|
  template "/etc/#{netfile}" do
    # notifies :run, "execute[netstart]"
  end
end

%w[sndiod resolvd].each do |srv|
  service srv do
    action %i[stop disable]
  end
end

file "/etc/motd" do
  action :edit
  motd = node[:motd] || ""
  block do |data|
    header = data.lines.first

    parts = [header, '']
    unless node[:motd].nil?
      parts << motd
      parts << ''
    end
    data.replace parts.join("\n")
  end
end

service "unbound" do
  action %i[enable start]
end

sysctl "base" do
  settings %w[
    ddb.console=0
    ddb.panic=0
    kern.splassert=3
    machdep.allowaperture=0
    kern.nosuidcoredump=2
    kern.bufcachepercent=90
    kern.maxfiles=8192
    kern.maxproc=2048
    kern.maxclusters=32768
  ]
end
