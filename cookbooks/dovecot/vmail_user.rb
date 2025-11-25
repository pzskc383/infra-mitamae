# Create vmail group
group "vmail"

# Create vmail user
execute "create vmail user" do
  command "useradd -g vmail -d /var/vmail -s /sbin/nologin -c 'Virtual Mail User' vmail"
  user "root"
  not_if "id vmail"
end

# Create vmail directory
directory "/var/vmail" do
  mode "0775"
  owner "vmail"
  group "vmail"
end
