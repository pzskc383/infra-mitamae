# OpenSMTPD mail server cookbook
node[:mail_domains] ||= {}
node[:mail_admin_aliases] ||= %w[MAILER-DAEMON postmaster hostmaster
                                 operator www security manager dumper
                                 noc webmaster]

# Determine mail role for this host based on mail_domains configuration
primary_domains = []
relay_domains = []
mail_accounts = []

node[:mail_domains].each do |domain, config|
  servers = config[:servers] || []
  next if servers.empty?

  if servers[0] == node[:hostname]
    config[:redirects] ||= []
    config[:accounts] ||= []

    primary_domains << domain

    config[:accounts].each do |acc|
      mail_accounts << {
        email: "#{acc[:username]}@#{domain}",
        password_hash: acc[:password_hash]
      }
    end
  elsif servers.include?(node[:hostname])
    relay_domains << domain
  end
end

mail_role = primary_domains.empty? ? "secondary" : "primary"

# Store calculated values for use in templates
node[:mail_role] = mail_role
node[:mail_primary_domains] = primary_domains
node[:mail_relay_domains] = relay_domains

# fqdn+fcrdns
template "/etc/mail/mailname" do
  source "templates/mailname.erb"
  mode "0664"
  variables(
    fqdn: node[:fqdn]
  )
  notifies :restart, "service[smtpd]"
end

# For primary servers, set up virtual users and password file
if mail_role == "primary"
  include_recipe "mailpasswd_group.rb"
  include_recipe "../dovecot/vmail_user.rb"

  execute "usermod -G _mailpasswd _smtpd" do
    not_if "id -nG _smtpd | grep -q _mailpasswd"
  end

  template "/etc/mail/passwd" do
    source "templates/passwd.erb"
    variables(accounts: mail_accounts)

    mode "0640"
    group "_mailpasswd"
  end
end

template "/etc/mail/vdomains" do
  source "templates/vdomains.erb"
  mode "0660"
  group "_smtpd"
  variables(domains: (primary_domains + relay_domains))
  notifies :run, "execute[makemap vdomains]"
  notifies :restart, "service[smtpd]"
end

if mail_role == "primary"
  template "/etc/mail/vusers" do
    source "templates/vusers.erb"
    mode "0660"
    group "_smtpd"
    variables(
      primary_domains: primary_domains,
      domains: node[:mail_domains],
      accounts: mail_accounts
    )
    notifies :run, "execute[makemap vusers]"
    notifies :restart, "service[smtpd]"
  end
end

# file "/etc/mail/aliases" do
#   action :edit
#   source "templates/aliases.erb"
#   mode "0644"
#   variables(
#     admin_aliases: node[:mail_admin_aliases],
#     admin_address: node[:global_admin_address] || mail_domains.values.first[:main_account]
#   )
#   notifies :run, "execute[newaliases]"
# end

## Rebuild aliases database
# execute "newaliases" do
#   action :nothing
#   command "makemap -t aliases /etc/mail/aliases"
# end

execute "makemap vdomains" do
  action :nothing
  command "makemap -t set /etc/mail/vdomains"
end

execute "makemap vusers" do
  action :nothing
  command "makemap -t aliases /etc/mail/vusers"
end

execute "makemap passwd" do
  action :nothing
  command "makemap -t set /etc/mail/passwd"
end

# Deploy main smtpd configuration
template "/etc/mail/smtpd.conf" do
  source "templates/smtpd.conf.erb"
  mode "0640"
  variables(
    fqdn: node[:fqdn],
    mail_role: mail_role,
    primary_domains: primary_domains,
    relay_domains: relay_domains,
    tls_cert: node[:mail_tls_cert] || "/etc/ssl/fqdn.crt",
    tls_key: node[:mail_tls_key] || "/etc/ssl/private/fqdn.key",
    mail_domains: node[:mail_domains]
  )

  notifies :run, "execute[restart_smtpd]"
end

# Enable and start smtpd service
service "smtpd" do
  action %i[enable start]
  only_if "smtpd -n"
end

execute "restart_smtpd" do
  action :nothing

  command "rcctl restart smtpd"
  only_if "smtpd -n"
end

include_recipe "../pf/defines.rb"

# Add PF firewall rules for mail services
pf_snippet "mail" do
  content <<~PF
    # mail services
    table <spamd> persist
    pass in proto tcp to port { smtp#{' submission imaps' if mail_role == 'primary'} }
  PF
end
