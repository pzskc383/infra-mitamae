file "/etc/sysctl.conf"

execute "reload sysctl" do
  action :nothing
  command "sysctl -f /etc/sysctl.conf"
end

define :sysctl, settings: [] do
  settings = params[:settings]
  lines_in_file "/etc/sysctl.conf" do
    lines settings

    notifies :run, "execute[reload sysctl]"
  end
end
