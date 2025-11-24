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
    marker_start = "# BEGIN MITAMAE MANAGED BLOCK"
    marker_end = "# END MITAMAE MANAGED BLOCK"

    new_block = <<~'SHELL'
      case "$SHELL" in
      *ksh)
          ENV=$HOME/.kshrc
          export ENV
          ;;
      esac
    SHELL

    # Remove existing managed block if present
    content.gsub!(/#{Regexp.escape(marker_start)}.*?#{Regexp.escape(marker_end)}\n?/m, '')

    # Append new block
    content << "\n#{marker_start}\n#{new_block}#{marker_end}\n"
  end
end

