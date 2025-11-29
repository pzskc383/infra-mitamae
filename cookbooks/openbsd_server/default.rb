include_recipe "defines.rb"

openbsd_package "vim" do
  action :install
  flavor "no_x11"
end

%w[
  /etc/daily.local /etc/weekly.local
  /etc/newsyslog.conf /etc/syslog.conf
  /etc/ntpd.conf /var/unbound/etc/unbound.conf
].each do |fn|
  remote_file fn do
    source "files/#{File.basename(fn)}"
    mode "0640"
  end
end

file "/etc/resolv.conf" do
  mode "0644"
end

template "/etc/hostname.vio0"
template "/etc/mygate"

%w[sndiod resolvd].each do |srv|
  service srv do
    action %i[stop disable]
  end
end

service "unbound" do
  action %i[enable start]
end

[
  "ddb.console=0",
  "ddb.panic=0",
  "kern.splassert=3",
  "machdep.allowaperture=0",
  "kern.nosuidcoredump=2"
].each do |line|
  sysctl line
end
