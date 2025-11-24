# PF firewall cookbook
#
# Services register firewall rules with:
#   pf_snippet "myservice" do
#     content "pass in proto tcp to port 443"
#   end

# Sysctl network and security tuning
block_in_file "/etc/sysctl.conf" do
  content <<~SYSCTL
    net.inet.ip.forwarding=1
    net.inet6.ip6.forwarding=1
    net.inet.ip.multipath=1
    net.inet6.ip6.multipath=1
    net.inet.icmp.maskrepl=0
    net.inet.icmp.rediraccept=0
    net.inet.icmp.tstamprepl=0
    net.inet6.icmp6.rediraccept=0
    net.inet.tcp.rfc1323=1
    net.inet.tcp.rfc3390=1
    net.inet.tcp.sack=1
    net.inet.tcp.ecn=1
    net.inet.tcp.mssdflt=1440
    net.inet.ip.mtudisc=1
    net.inet.gre.allow=1
    net.inet.ipcomp.enable=1
    net.pipex.enable=1
    net.inet.tcp.synuselimit=100
    net.inet.tcp.synhashsize=8192
    net.inet.tcp.syncachelimit=65536
    ddb.console=0
    ddb.panic=0
    kern.splassert=3
    machdep.allowaperture=0
    kern.nosuidcoredump=2
  SYSCTL
end

# pflog interfaces
%w[hostname.pflog0 hostname.pflog1].each do |f|
  file "/etc/#{f}" do
    mode "0640"
    owner "root"
    group "wheel"
    content "up"
  end
end

# Main pf config
remote_file "/etc/pf.conf" do
  mode "0640"
  owner "root"
  group "wheel"
end

# PF directory
directory "/etc/pf" do
  mode "0750"
  owner "root"
  group "wheel"
end

# PF tables
remote_file "/etc/pf/martians.table" do
  mode "0640"
  owner "root"
  group "wheel"
end

file "/etc/pf/banned.table" do
  mode "0600"
  owner "root"
  group "wheel"
  content ""
  not_if "stat /etc/pf/banned.table"
end

# PF static anchors
%w[block.anchor icmp.anchor scrub.anchor outgoing.anchor].each do |f|
  remote_file "/etc/pf/#{f}" do
    mode "0640"
    owner "root"
    group "wheel"
  end
end

# Dynamic services anchor from node attributes
# Services notify this with: notifies :create, "template[/etc/pf/services.local.anchor]"
template "/etc/pf/services.anchor" do
  action :nothing
  mode "0640"
  owner "root"
  group "wheel"
  # variables(node: node)
end
