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

service "sshd" do
  action :nothing
  not_if "sshd -t"
end

lines_in_file "/etc/ssh/sshd_config" do
  lines %w[
    Port=38322
    PermitRootLogin=prohibit-password
    PasswordAuthentication=no
    KexAlgorithms=curve25519-sha256curve25519-sha256@libssh.orgdiffie-hellman-group16-sha512diffie-hellman-group18-sha512diffie-hellman-group-exchange-sha256 
    MACs=umac-128-etm@openssh.comhmac-sha2-256-etm@openssh.comhmac-sha2-512-etm@openssh.com 
    HostKeyAlgorithms=ssh-ed25519rsa-sha2-256rsa-sha2-512 
  ]

  notifies :restart, "service[sshd]"
end

include_recipe "../pf/defines.rb"

pf_snippet "pass proto tcp to port 38322 set queue(ssh_bulk, ssh_prio)"
