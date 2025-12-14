group "vmail"

execute "create vmail user" do
  command "useradd -g vmail -d /var/vmail -s /sbin/nologin -c 'Virtual Mail User' vmail"
  not_if "id vmail"
end

directory "/var/vmail" do
  mode "0775"
  owner "vmail"
  group "vmail"
end
