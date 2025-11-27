# HTTPD cookbook - OpenBSD's httpd web server with relayd

remote_file '/etc/httpd.macro.conf' do
  source 'files/httpd.macro.conf'
  notifies :restart, 'service[httpd]'
  notifies :restart, 'service[relayd]'
end

remote_file '/etc/relayd.conf' do
  source 'files/relayd.conf'
  notifies :restart, 'service[relayd]'
  only_if "relayd -n"
end

template '/etc/httpd.conf' do
  source 'templates/httpd.conf.erb'
  notifies :restart, 'service[httpd]'
  only_if "httpd -n"
end

directory '/var/www/errdocs' do
  mode '0755'
  owner 'root'
  group 'daemon'
end

remote_file "/var/www/errdocs/err.html" do
  source 'files/err.html'
  mode '0644'
  owner 'root'
  group 'daemon'
end

%w[bg.png home.png index.html robots.txt].each do |fname|
  remote_file "/var/www/htdocs/#{fname}" do
    source "files/index/#{fname}"
    mode '0644'
    owner 'root'
    group 'daemon'
  end
end

service 'httpd' do
  action %i[enable start]
end

service 'relayd' do
  action %i[enable start]
end

pf_snippet 'httpd' do
  content <<~PF
    # http and https services
    pass proto tcp to port { http https }
  PF
end
