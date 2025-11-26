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
  content <<~SNIPPET
    case "$SHELL" in
    *ksh)
        ENV=$HOME/.kshrc
        export ENV
        ;;
    esac
  SNIPPET
end

execute "restart_sshd" do
  action :nothing
  command "rcctl restart sshd"
  not_if "sshd -t"
end

{
  "Port" => "38322",
  "PermitRootLogin" => "prohibit-password",
  "PasswordAuthentication" => "no"
}.each do |k, v|
  config_set "/etc/ssh/sshd_config" do
    key k
    value v
    notifies :run, "execute[:restart_sshd]"
  end
end

include_recipe "../pf/dynamic.rb"

pf_snippet "pass proto tcp to port 38322"
