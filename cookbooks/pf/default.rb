# PF firewall cookbook
node.reverse_merge!({
  pf_enable_relayd: false,
})

include_recipe 'defines.rb'

include_recipe '../openbsd_server/defines.rb'

sysctl "pf" do
  settings %w[
    net.inet.ip.forwarding=1
    net.inet6.ip6.forwarding=1
    net.inet.icmp.maskrepl=0
    net.inet.icmp.tstamprepl=0
    net.inet.icmp.rediraccept=0
    net.inet6.icmp6.rediraccept=0
    net.inet.gre.allow=1
    net.inet.ipcomp.enable=1
    net.inet.tcp.rfc3390=1
    net.inet.ip.ifq.maxlen=8192
    net.inet.tcp.mssdflt=1440
    net.inet.ip.mtudisc=0
  ]
end

%w[hostname.pflog0 hostname.pflog1].each do |f|
  file "/etc/#{f}" do
    content "up"
  end
end
directory "/etc/pf" do
  mode "0700"
end

file "/etc/pf/banned.table" do
  content ""
  not_if "test -f /etc/pf/banned.table"
end


link "/etc/rc.d/pflogd1" do
  to "/etc/rc.d/pflogd"
end

service "pflogd1" do
  action [:enable]
end

execute "rcctl set pflogd1 flags '-i pflog1 -s 1440'" do
  not_if "grep -qE 'pflogd1.*pflog1' /etc/rc.conf.local"
end

service "pflogd1" do
  action [:start]
end