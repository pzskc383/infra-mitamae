node[:relayd_domains] ||= []
node[:relayd_domains] << "pzskc383.net"
node[:relayd_domains] << "pzskc383.dp.ua"

notify!("create@template[/etc/relayd.conf]")

remote_file "/etc/httpd.conf.d/main_pzskc383.conf" do
  source "templates/main_pzskc383.conf.erb"
  notifies :reload, 'service[httpd]'
end

node[:httpd_config_files] << "main_pzskc383.conf"
notify!("create@template[/etc/httpd.conf]")

%w[cgitrc cgit-head.inc.html].each do |fn|
  remote_file "/var/www/conf/#{fn}" do
    source "files/cgit/#{fn}"
    mode '0444'
    owner 'www'
    group 'www'
  end
end

directory "/var/www/htdocs/pzskc383"

%w[bg.png home.png index.html robots.txt favicon.ico].each do |fname|
  remote_file "/var/www/htdocs/pzskc383/#{fname}" do
    source "files/#{fname}"
    mode '0644'
    owner 'root'
    group 'daemon'
  end
end

# include_recipe "compile_chroma.rb"
