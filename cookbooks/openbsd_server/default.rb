# cron 'echo hi'

openbsd_package "vim" do
  action :install
  flavor "no_x11"
end

openbsd_package "nnn" do
  action :install
  # flavor "nerd"
end
