openbsd_package "lego" do
  action :install
end

directory "/var/lego" do
  mode "0750"
end
