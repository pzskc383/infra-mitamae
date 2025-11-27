# Rspamd spam filtering and DKIM signing cookbook
# Only runs on primary mail servers

# Skip if not a primary mail server
if node[:mail_role] != "primary"
  ::MItamae.logger.warn "Not a primary mail server, skipping rspamd setup"
  return
end

# Install rspamd packages
%w[rspamd--hyperscan opensmtpd-filter-rspamd].each do |pkg|
  openbsd_package pkg do
    action :install
  end
end

# Deploy rspamd configuration files
directory "/etc/rspamd/local.d" do
  mode "0755"
  owner "root"
  group "wheel"
end

# DKIM signing configuration
template "/etc/rspamd/local.d/dkim_signing.conf" do
  source "templates/local.d/dkim_signing.conf.erb"
  mode "0644"
  owner "root"
  group "wheel"
  variables(
    domains: node[:mail_primary_domains] || []
  )
  notifies :restart, "service[rspamd]"
end

# ARC signing configuration
template "/etc/rspamd/local.d/arc.conf" do
  source "templates/local.d/arc.conf.erb"
  mode "0644"
  owner "root"
  group "wheel"
  variables(
    domains: node[:mail_primary_domains] || []
  )
  notifies :restart, "service[rspamd]"
end

# Other rspamd configs
%w[options.inc spf.conf greylist.conf].each do |config|
  template "/etc/rspamd/local.d/#{config}" do
    source "templates/local.d/#{config}.erb"
    mode "0644"
    owner "root"
    group "wheel"
    notifies :restart, "service[rspamd]"
  end
end

# Worker configs
%w[worker-controller.inc worker-fuzzy.inc worker-normal.inc worker-proxy.inc].each do |config|
  template "/etc/rspamd/local.d/#{config}" do
    source "templates/local.d/#{config}.erb"
    mode "0644"
    owner "root"
    group "wheel"
    notifies :restart, "service[rspamd]"
  end
end

# Disable unwanted modules
disabled_modules = %w[
  antivirus asn clickhouse dcc elastic emails external_services force_actions
  history_redis ip_score maillist metadata_exporter metric_exporter mid
  milter_headers mime_types multimap neural once_received p0f phishing
  ratelimit replies rbl reputation rspamd_update spamassassin trie whitelist
  url_redirector
]

disabled_modules.each do |mod|
  file "/etc/rspamd/local.d/#{mod}.conf" do
    content "enabled = false;\n"
    mode "0644"
    owner "root"
    group "wheel"
    notifies :restart, "service[rspamd]"
  end
end

# Create DKIM/ARC keys directory
directory "/var/rspamd/keys" do
  mode "0755"
  owner "root"
  group "_rspamd"
end

# # Generate DKIM/ARC keys per domain
# (node.mail_primary_domains || []).each do |domain|
#   # RSA-2048 key with selector 'r'
#   execute "generate DKIM RSA key for #{domain}" do
#     command <<~CMD
#       rspamadm dkim_keygen -s r -d #{domain} -t RSA -b 2048 \
#         -k /var/rspamd/keys/#{domain}.r.key -o dns \
#         > /var/rspamd/keys/#{domain}.r.zonepart && \
#       chown root:_rspamd /var/rspamd/keys/#{domain}.r.* && \
#       chmod 640 /var/rspamd/keys/#{domain}.r.*
#     CMD
#     user "root"
#     not_if "test -f /var/rspamd/keys/#{domain}.r.key"
#   end

#   # ED25519 key with selector 'e'
#   execute "generate DKIM ED25519 key for #{domain}" do
#     command <<~CMD
#       rspamadm dkim_keygen -s e -d #{domain} -t ED25519 \
#         -k /var/rspamd/keys/#{domain}.e.key -o dns \
#         > /var/rspamd/keys/#{domain}.e.zonepart && \
#       chown root:_rspamd /var/rspamd/keys/#{domain}.e.* && \
#       chmod 640 /var/rspamd/keys/#{domain}.e.*
#     CMD
#     user "root"
#     not_if "test -f /var/rspamd/keys/#{domain}.e.key"
#   end
# end

# Enable and start rspamd service
service "rspamd" do
  action %i[enable start]
end
