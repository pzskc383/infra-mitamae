define :sysctl, name: nil do
  line = params[:name]
  line_set "/etc/sysctl.conf" do
    set line
    notifies :run, "reload sysctl"
  end
end

execute "reload sysctl" do
  action :nothing
  command "sysctl -f /etc/sysctl.conf"
end
