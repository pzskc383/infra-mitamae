include_recipe '../lego_fqdn/common.rb'

remote_file "/var/lego/hook.sh" do
  source "files/hook.sh"
  mode "0755"
end

template "/var/lego/lego.sh" do
  source "templates/lego.sh.erb"
  mode "0755"
  variables(
    lego_certs: node[:lego_certs] || [],
    admin_email: node[:lego_admin_email]
  )
end

template "/var/lego/distfile" do
  source "templates/distfile.erb"
  mode "0644"
  variables(
    lego_certs: node[:lego_certs] || [],
    all_hosts: node[:hosts] || [],
    current_host: node[:hostname]
  )
end

execute "acquire initial certificates" do
  command "/var/lego/lego.sh run"
  # Only run if at least one cert is missing
  not_if "true"
  # not_if do
  #   certs = node[:lego_certs] || []
  #   certs.empty? || certs.all? do |cert|
  #     domain = cert[:domains].first
  #     File.exist?("/etc/ssl/#{domain}.crt") && File.exist?("/etc/ssl/private/#{domain}.key")
  #   end
  # end
end

cron "lego certificate renewal" do
  hour "3"
  minute "17"
  day "*/7"
  command "/var/lego/lego.sh renew"
end
