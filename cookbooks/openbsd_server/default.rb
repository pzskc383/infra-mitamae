include_recipe "defines.rb"

openbsd_package "vim" do
  action :install
  flavor "no_x11"
end

Dir.glob("cookbooks/openbsd_server/files/**/*.*").each do |fn|
  fn.sub!("cookbooks/openbsd_server/files", "")

  remote_file fn do
    source :auto
    mode "0640"
  end
end

template "/etc/hostname.vio0"
template "/etc/mygate"

file "/etc/resolv.conf" do
  mode "0644"
end

service "unbound" do
  action %i[enable restart]
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
