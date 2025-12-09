# PF firewall cookbook
node.reverse_merge!({
  pf_enable_relayd: false,
  pf_has_local_services: ::File.exist?("/etc/pf/services.local.anchor")
})

include_recipe 'defines.rb'

include_recipe '../openbsd_server/defines.rb'

[
  "net.inet.ip.forwarding=1",
  "net.inet6.ip6.forwarding=1",
  "net.inet.ip.multipath=1",
  "net.inet6.ip6.multipath=1",
  "net.inet.icmp.maskrepl=0",
  "net.inet.icmp.rediraccept=0",
  "net.inet.icmp.tstamprepl=0",
  "net.inet6.icmp6.rediraccept=0",
  "net.inet.tcp.rfc1323=1",
  "net.inet.tcp.rfc3390=2",
  "net.inet.tcp.sack=1",
  "net.inet.tcp.ecn=1",
  "net.inet.tcp.mssdflt=1440",
  "net.inet.ip.mtudisc=1",
  "net.inet.gre.allow=1",
  "net.inet.ipcomp.enable=1",
  "net.pipex.enable=1",
  "net.inet.tcp.synuselimit=10000"
].each do |line|
  sysctl line
end

%w[hostname.pflog0 hostname.pflog1].each do |f|
  pf_conf "/etc/#{f}" do
    content "up"
  end
end
directory "/etc/pf" do
  mode "0700"
end

pf_conf "/etc/pf/martians.table"

pf_conf "/etc/pf/banned.table" do
  content ""
  not_if "test -f /etc/pf/banned.table"
end

%w[block.anchor icmp.anchor scrub.anchor outgoing.anchor].each do |f|
  pf_conf "/etc/pf/#{f}"
end

template "/etc/pf.conf" do
  mode "0600"
  notifies :run, "execute[reload_pf]"
end


link "/etc/rc.d/pflogd1" do
  to "/etc/rc.d/pflogd"
end

service "pflogd1" do
  action [:enable]
end

execute "rcctl set pflogd1 flags '-i pflog1'" do
  not_if "grep -qE 'pflogd1.*pflog1' /etc/rc.conf.local"
end

service "pflogd1" do
  action [:start]
end