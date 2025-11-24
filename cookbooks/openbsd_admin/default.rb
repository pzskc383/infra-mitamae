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

remote_file "/etc/doas.conf"
remote_file "/etc/tmux.conf"

remote_file "/root/.kshrc" do
  source "files/root.kshrc"
end

block_in_file "/root/.profile" do
  content <<~EOF
    case "$SHELL" in
    *ksh)
        ENV=$HOME/.kshrc
        export ENV
        ;;
    esac
  EOF
end

line_in_file "/etc/ssh/sshd_config" do
  line "Port 38322"
  match_rx %r{^#?(\s*)?Port\s}
end
