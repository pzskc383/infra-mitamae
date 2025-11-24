openbsd_package "vim" do
  action :install
  flavor "no_x11"
end

Dir.glob("cookbooks/openbsd_server/files/**/*.*").map do |fn|
  fn.sub("cookbooks/openbsd_server/files", "")
end.each do |fn|
  remote_file fn do
    action :create
    source :auto
  end
end

template "/etc/hostname.vio0" do
  source :auto
end
