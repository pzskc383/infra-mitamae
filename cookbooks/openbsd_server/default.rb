openbsd_package "vim" do
  action :install
  flavor "no_x11"
end

Dir.glob("cookbooks/openbsd_server/files/**/*.*").each do |fn|
  fn.sub!("cookbooks/openbsd_server/files", "")

  remote_file fn do
    action :create
    source :auto
    mode "0640"
    user "root"
    group "wheel"
  end
end

template "/etc/hostname.vio0" do
  source :auto
end

file "/etc/resolv.conf" do
  mode "0644"
  user "root"
  group "wheel"
end

service "unbound" do
  action %i[enable restart]
end
