openbsd_package "git"
openbsd_package "zsh"
openbsd_package "htop"
openbsd_package "wget"
openbsd_package "ncdu"

openbsd_package "rsync" do
  flavor nil
end
openbsd_package "nnn" do
  flavor nil
end

remote_file "/etc/doas.conf" do
  action :create
  source :auto
end

remote_file "/etc/tmux.conf" do
  action :create
  source :auto
end

remote_file "/root/.kshrc" do
  action :create
  source "files/root.kshrc"
  user "root"
  group "wheel"
  mode "0644"
end

file "/root/.profile" do
  action :edit
  block do |content|
    content
  end
end
