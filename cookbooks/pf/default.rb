include_recipe 'dynamic.rb'

include_recipe '../openbsd_server/defines.rb'

define :pf_conf, mode: "0600", content: nil do
  file params[:name] do
    mode params[:mode]
    content params[:content] if params[:content]
    notifies :run, "execute[reload_pf]"
  end
end

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
    mode "0600"
    content "up"
  end
end

pf_conf "/etc/pf.conf" do
  mode "0600"
end

pf_conf "/etc/pf" do
  mode "0700"
end

pf_conf "/etc/pf/martians.table" do
  mode "0600"
end

pf_conf "/etc/pf/banned.table" do
  mode "0600"
  content ""
  not_if "stat /etc/pf/banned.table"
end

%w[block.anchor icmp.anchor scrub.anchor outgoing.anchor].each do |f|
  pf_conf "/etc/pf/#{f}" do
    mode "0600"
  end
end
