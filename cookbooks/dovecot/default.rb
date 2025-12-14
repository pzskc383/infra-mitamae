openbsd_package "dovecot"
openbsd_package "dovecot-pigeonhole"

include_recipe "../smtpd/mailpasswd_group.rb"

execute "usermod -G _mailpasswd _dovecot" do
  not_if "id -nG _dovecot | grep -qF _mailpasswd"
end

include_recipe "vmail_user.rb"

execute "usermod -G _dovecot vmail" do
  not_if "id -nG vmail |grep -qF _dovecot"
end

tls_cert = node[:mail_tls_cert] || "/etc/ssl/fqdn.crt"
tls_key = node[:mail_tls_key] || "/etc/ssl/private/fqdn.key"

lines_in_file "/etc/dovecot/dovecot.conf" do
  lines [
    "protocols = imap lmtp",
    "listen = #{node[:network_setup][:v4][:address]},#{node[:network_setup][:v6][:address]}",
    "login_greeting = IMAP ready",
    "submission_host = 127.0.0.1:587",
    "mail_debug = yes"
  ]
end

execute "generate_dovecot_dhparam" do
  command "openssl dhparam -outform PEM -out /etc/dovecot/dh.pem 2048"
  not_if { ::File.exist?("/etc/dovecot/dh.pem") }
end

lines_in_file "/etc/dovecot/conf.d/10-ssl.conf" do
  lines [
    "ssl = yes",
    "ssl_cert = <#{tls_cert}",
    "ssl_key = <#{tls_key}",
    "ssl_dh = </etc/dovecot/dh.pem"
  ]

  notifies :restart, "service[dovecot]"
end

lines_in_file "/etc/dovecot/conf.d/10-mail.conf" do
  lines [
    "mail_home = /var/vmail/%d/%n",
    {
      line: "mail_location = maildir:~/mail:LAYOUT=fs",
      regex: %r{^#mail_location}
    },
    "mail_uid = vmail",
    "mail_gid = vmail",
    "mmap_disable = yes",
    "mail_plugin_dir = /usr/local/lib/dovecot"
  ]

  notifies :restart, "service[dovecot]"
end

remote_file "/etc/dovecot/conf.d/auth-passwdfile.conf.ext" do
  source "files/auth-passwdfile.conf.ext"
  mode "0644"
  owner "root"
  group "wheel"

  notifies :restart, "service[dovecot]"
end

lines_in_file "/etc/dovecot/conf.d/10-auth.conf" do
  lines [
    {
      regexp: %r{^!include auth-system\.conf\.ext},
      line: "#!include auth-system.conf.ext",
      append: false
    },
    {
      regexp: %r{.*#?!include auth-passwdfile\.conf\.ext},
      line: "!include auth-passwdfile.conf.ext"
    }
  ]

  notifies :restart, "service[dovecot]"
end

file "/etc/dovecot/conf.d/10-master.conf" do
  action :edit
  block do |data|
    data.gsub!(%r/service lmtp {\n.+?\n}\n/m) do |match|
      match.gsub!(%r{\s*executable =.*$}, '')
      match.gsub!(%r[\n}]m, "\n  executable = lmtp -L\n}")
      # match.gsub!(%r{\s*user =.*$}, '')
      # match.gsub!(%r[\n}]m, "\n  user = vmail\n}")
    end

    data.gsub!(%r/service auth {\n.+?\n}\n/m) do |match|
      auth_userdb_block = <<~EO_LISTENER.gsub!(%r{^}, "  ")
        unix_listener auth-userdb {
          mode = 0666
          user = vmail
          group = vmail
        }
      EO_LISTENER
      match.gsub!(%r/ +unix_listener auth-userdb {\n.+?\n\s+}\n/m, auth_userdb_block)

      match.gsub!(%r{\s*#?extra_groups =.*$}, '')
      match.gsub!(%r/\n}/m, "\n  extra_groups = _mailpasswd\n}")
    end

    data.gsub!(%r/service auth-worker {\n.+?\n}\n/m) do |match|
      match.gsub!(%r{\s*#?user =.*$}, '')
      match.gsub!(%r[\n}]m, "\n  user = $default_internal_user\n}")
    end
  end

  notifies :restart, "service[dovecot]"
end

file "/etc/dovecot/conf.d/20-lmtp.conf" do
  action :edit
  block do |data|
    data.gsub!(%r/protocol lmtp\s*\{.+?\n\}\n/m) do |match|
      match.gsub!(%r{\s*#?info_log_path =.*$}, '')
      match.gsub!(%r{\s*#?log_path =.*$}, '')
      match.gsub!(%r{\s*#?syslog_facility =.*$}, '')

      match.gsub!(%r[\n}]m, "\n  info_log_path =\n}")
      match.gsub!(%r[\n}]m, "\n  log_path =\n}")
      match.gsub!(%r[\n}]m, "\n  syslog_facility = mail\n}")
    end
  end

  notifies :restart, "service[dovecot]"
end

block_in_file "/etc/dovecot/conf.d/10-metrics.conf" do
  content <<~EOCONF
    service stats {
      client_limit = 100
      unix_listener stats-writer {
        user = vmail
      }
    }
  EOCONF

  notifies :restart, "service[dovecot]"
end

service "dovecot" do
  action %i[enable start]

  only_if "doveconf"
end

include_recipe "../pf/defines.rb"
pf_snippet "dovecot" do
  content <<~PF
    pass in proto tcp to port imap
  PF
end
