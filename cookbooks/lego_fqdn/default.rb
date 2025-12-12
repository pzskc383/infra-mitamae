include_recipe 'common.rb'

remote_file "/var/lego/hook_fqdn.sh" do
  source "files/hook_fqdn.sh"
  mode "0755"
end

template "/var/lego/lego_fqdn.sh" do
  source "templates/lego_fqdn.sh.erb"
  mode "0755"
  variables(admin_email: node[:lego_admin_email])
end

execute "acquire initial fqdn certificates" do
  command "/var/lego/lego_fqdn.sh run"
  not_if do
    File.exist? "/etc/ssl/fqdn.crt"
  end
end

cron_rand = ::Random.rand(60*24)
cron "lego fqdn certificate renewal" do
  hour (cron_rand % 24).to_s
  minute (cron_rand % 60).to_s
  day "*/9"
  command "/var/lego/lego_fqdn.sh renew"
end
