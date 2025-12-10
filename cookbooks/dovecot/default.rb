# Dovecot IMAP server cookbook
# Only runs on primary mail servers

# Skip if not a primary mail server
if node[:mail_role] != "primary"
  ::MItamae.logger.info "Not a primary mail server, skipping dovecot setup"
  return
end

# Install dovecot
openbsd_package "dovecot" do
  action :install
end

include_recipe "../smtpd/mailpasswd_group.rb"

execute "usermod -G _mailpasswd _dovecot" do
  not_if "id -nG _dovecot | grep -qF _mailpasswd"
end

include_recipe "vmail_user.rb"

execute "usermod -G _dovecot vmail" do
  not_if "id -nG vmail |grep -qF _dovecot"
end

# Configure dovecot using line_in_file to preserve defaults
tls_cert = node[:mail_tls_cert] || "/etc/ssl/#{node[:domain]}.crt"
tls_key = node[:mail_tls_key] || "/etc/ssl/private/#{node[:domain]}.key"

# 10-ssl.conf
line_in_file "/etc/dovecot/conf.d/10-ssl.conf" do
  pattern(%r{^#?ssl =})
  line "ssl = yes"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-ssl.conf" do
  pattern(%r{^#?ssl_cert =})
  line "ssl_cert = <#{tls_cert}"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-ssl.conf" do
  pattern(%r{^#?ssl_key =})
  line "ssl_key = <#{tls_key}"
  notifies :restart, "service[dovecot]"
end

# 10-mail.conf
line_in_file "/etc/dovecot/conf.d/10-mail.conf" do
  pattern(%r{^#?mail_home =})
  line "mail_home = /var/vmail/%u"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-mail.conf" do
  pattern(%r{^#?mail_location =})
  line "mail_location = maildir:/var/vmail/%u/mail"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-mail.conf" do
  pattern(%r{^#?mail_uid =})
  line "mail_uid = vmail"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-mail.conf" do
  pattern(%r{^#?mail_gid =})
  line "mail_gid = vmail"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-mail.conf" do
  pattern(%r{^#?mmap_disable =})
  line "mmap_disable = yes"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-mail.conf" do
  pattern(%r{^#?first_valid_uid =})
  line "first_valid_uid = 1000"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-mail.conf" do
  pattern(%r{^#?mail_plugin_dir =})
  line "mail_plugin_dir = /usr/local/lib/dovecot"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-mail.conf" do
  pattern(%r{^#?mbox_write_locks =})
  line "mbox_write_locks = fcntl"
  notifies :restart, "service[dovecot]"
end

# 10-master.conf - auth service configuration
# block_in_file "/etc/dovecot/conf.d/10-master.conf" do
#   marker_start "  # BEGIN mitamae auth-userdb"
#   marker_end "  # END mitamae auth-userdb"

#   content <<~CONF
#     unix_listener auth-userdb {
#       mode = 0666
#       user  = vmail
#       group = vmail
#     }
#   CONF
#   notifies :restart, "service[dovecot]"
# end

# block_in_file "/etc/dovecot/conf.d/10-master.conf" do
#   marker_start "# BEGIN mitamae extra_groups"
#   marker_end "# END mitamae extra_groups"

#   content "extra_groups = _mailpasswd\n"
#   notifies :restart, "service[dovecot]"
# end

# 10-auth.conf - enable passwdfile auth, disable system auth
line_in_file "/etc/dovecot/conf.d/10-auth.conf" do
  pattern(%r{^#?!include auth-passwdfile\.conf\.ext})
  line "!include auth-passwdfile.conf.ext"
  notifies :restart, "service[dovecot]"
end

line_in_file "/etc/dovecot/conf.d/10-auth.conf" do
  pattern(%r{^!include auth-system\.conf\.ext})
  line "#!include auth-system.conf.ext"
  notifies :restart, "service[dovecot]"
end

# Deploy auth-passwdfile.conf.ext
template "/etc/dovecot/conf.d/auth-passwdfile.conf.ext" do
  source "templates/auth-passwdfile.conf.ext.erb"
  mode "0644"
  owner "root"
  group "wheel"
  notifies :restart, "service[dovecot]"
end

# Enable dovecot service
service "dovecot" do
  action [:enable]
end
