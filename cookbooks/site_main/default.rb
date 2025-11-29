%w[main redirects].each do |p|
  remote_file "/etc/httpd.conf.d/#{p}_pzskc383.conf" do
    source "templates/#{p}_pzskc383.conf.erb"
    notifies :restart, 'service[httpd]'
  end
end

directory "/var/www/sites/pzskc383"

%w[bg.png home.png index.html robots.txt].each do |fname|
  remote_file "/var/www/sites/pzskc383/#{fname}" do
    source "files/#{fname}"
    mode '0644'
    owner 'root'
    group 'daemon'
  end
end

local_ruby_block "add_httpd_relayd_configs" do
  node[:httpd_config_files] << "redirects_pzskc383.conf"
  node[:httpd_config_files] << "main_pzskc383.conf"
  node[:relayd_domains] << "pzskc383.net"
  node[:relayd_domains] << "pzskc383.dp.ua"

  block {} # rubocop:disable Lint/EmptyBlock

  notifies :create, 'template[/etc/httpd.conf]', :immediately
  notifies :create, 'template[/etc/relayd.conf]', :immediately
end
