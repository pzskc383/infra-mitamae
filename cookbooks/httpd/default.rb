# HTTPD cookbook - OpenBSD's httpd web server with relayd
node.reverse_merge!({
  relayd_has_fqdn_cert: false,
  httpd_config_files: []
})

directory "/etc/httpd.conf.d"

remote_file '/etc/httpd.conf.d/macro.conf' do
  source 'files/httpd.macro.conf'
  notifies :restart, 'service[httpd]'
  notifies :restart, 'service[relayd]'
end
template '/etc/httpd.conf' do
  source 'templates/httpd.conf.erb'
  variables(config_files: node[:httpd_config_files])
  notifies :restart, 'service[httpd]'
end

node[:relayd_has_fqdn_cert] = File.exist? '/etc/ssl/fqdn.crt'

directory '/etc/relayd.conf.d'
template '/etc/relayd.conf.d/http_relay.conf' do
  source 'templates/relayd.conf.d/http_relay.conf.erb'
end

template '/etc/relayd.conf' do
  source 'templates/relayd.conf.erb'
  variables(has_tls: node[:relayd_has_fqdn_cert] || !node[:relayd_domains].empty?)
  notifies :restart, 'service[relayd]'
end

template '/etc/relayd.conf.d/tls_relay.conf' do
  source 'templates/relayd.conf.d/tls_relay.conf.erb'
  variables(domains: node[:relayd_domains] || [])
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

directory "/var/www/sites/fqdn"
fqdn_hosts = {
  "v4" => node[:network_setup][:v4][:address],
  "v6" => node[:network_setup][:v6][:address],
  "host" => node[:fqdn]
}

fqdn_hosts.each do |type, value|
  directory "/var/www/sites/fqdn/#{type}"
  template "/var/www/sites/fqdn/#{type}/index.html" do
    source "templates/site.fqdn/hello.html.erb"
    variables(hostname: value)
    mode "0644"
    owner "root"
    group "daemon"
  end
end

template '/etc/httpd.conf.d/fqdn.conf' do
  source 'templates/httpd.conf.d/fqdn.conf.erb'
  variables(hosts: fqdn_hosts)
  notifies :restart, 'service[httpd]'
end

service 'httpd' do
  action %i[enable start]
  only_if "httpd -n"
end

service 'relayd' do
  action %i[enable start]
  only_if "relayd -n"
end

include_recipe "../pf/defines.rb"
pf_snippet 'httpd' do
  content <<~PF
    # http and https services
    pass proto tcp to port { http https }
  PF
end

node[:pf_enable_relayd] = true
notify!("template[/etc/pf.conf]") { action :create }