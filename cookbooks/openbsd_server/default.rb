define :sshd_param, value: nil do
  k, v = params[:name], params[:value]

  line_in_file "/etc/ssh/sshd_config" do
    line "#{k} #{v}"
    match_rx %r{^#?\s*#{k}\s}
  end
end

define :sysctl, value: nil do
  k, v = params[:name], params[:value]

  line_in_file "/etc/sysctl.conf" do
    line "#{k}=#{v}"
    match_rx %r{^#{k}=}
  end
end

openbsd_package "vim" do
  action :install
  flavor "no_x11"
end

Dir.glob("cookbooks/openbsd_server/files/**/*.*").each do |fn|
  fn.sub!("cookbooks/openbsd_server/files", "")

  remote_file fn do
    source :auto
    mode "0640"
  end
end

template "/etc/hostname.vio0"

file "/etc/resolv.conf" do
  mode "0644"
end

service "unbound" do
  action %i[enable restart]
end

{
  "net.inet.ip.forwarding" => "1",
  "net.inet6.ip6.forwarding" => "1",
  "net.inet.ip.multipath" => "1",
  "net.inet6.ip6.multipath" => "1",
  "net.inet.icmp.maskrepl" => "0",
  "net.inet.icmp.rediraccept" => "0",
  "net.inet.icmp.tstamprepl" => "0",
  "net.inet6.icmp6.rediraccept" => "0",
  "net.inet.tcp.rfc1323" => "1",
  "net.inet.tcp.rfc3390" => "1",
  "net.inet.tcp.sack" => "1",
  "net.inet.tcp.ecn" => "1",
  "net.inet.tcp.mssdflt" => "1440",
  "net.inet.ip.mtudisc" => "1",
  "net.inet.gre.allow" => "1",
  "net.inet.ipcomp.enable" => "1",
  "net.pipex.enable" => "1",
  "net.inet.tcp.synuselimit" => "100",
  "net.inet.tcp.synhashsize" => "8192",
  "net.inet.tcp.syncachelimit" => "65536",
  "ddb.console" => "0",
  "ddb.panic" => "0",
  "kern.splassert" => "3",
  "machdep.allowaperture" => "0",
  "kern.nosuidcoredump" => "2"
}.each do |sysctl_k, sysctl_v|
  sysctl(sysctl_k) { value sysctl_v }
end
