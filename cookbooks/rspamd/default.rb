if node[:mail_role] != "primary"
  ::MItamae.logger.warn "Not a primary mail server, skipping rspamd setup"
  return
end

%w[rspamd--hyperscan opensmtpd-filter-rspamd].each do |pkg|
  openbsd_package pkg do
    action :install
  end
end

directory "/etc/rspamd/local.d" do
  mode "0755"
  owner "root"
  group "wheel"
end

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

%w[options.inc spf.conf greylist.conf].each do |config|
  template "/etc/rspamd/local.d/#{config}" do
    source "templates/local.d/#{config}.erb"
    mode "0644"
    owner "root"
    group "wheel"
    notifies :restart, "service[rspamd]"
  end
end

%w[worker-controller.inc worker-fuzzy.inc worker-normal.inc worker-proxy.inc].each do |config|
  template "/etc/rspamd/local.d/#{config}" do
    source "templates/local.d/#{config}.erb"
    mode "0644"
    owner "root"
    group "wheel"
    notifies :restart, "service[rspamd]"
  end
end

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

directory "/var/rspamd/keys" do
  mode "0755"
  owner "root"
  group "_rspamd"
end

service "rspamd" do
  action %i[enable start]
end
