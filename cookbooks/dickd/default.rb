# dickd - erection serving daemon
dickd_bin = "/usr/local/bin/erection"
dickd_builddir = "/tmp/dickd-build"

directory dickd_builddir do
  not_if "test -x #{dickd_bin}"
end

%w[erection.c frames.h].each do |f|
  remote_file "#{dickd_builddir}/#{f}" do
    not_if "test -x #{dickd_bin}"
  end
end

execute "compile erection" do
  command "cc -o #{dickd_bin} #{dickd_builddir}/erection.c"
  not_if "test -x #{dickd_bin}"
end

directory dickd_builddir do
  action :delete
  only_if "test -d #{dickd_builddir}"
end

file "/etc/inetd.conf" do
  not_if "test -f /etc/inetd.conf"
  content ""
end

line_in_file "/etc/inetd.conf" do
  line "telnet stream tcp nowait root #{dickd_bin} erection"
  pattern(%r{^#?telnet\s+stream\s+tcp\s})
end

line_in_file "/etc/inetd.conf" do
  line "telnet stream tcp6 nowait root #{dickd_bin} erection"
  pattern(%r{^#?telnet\s+stream\s+tcp6\s})
  notifies :restart, "service[inetd]"
end

pf_snippet "pass proto tcp to port telnet"

service "inetd" do
  action %i[enable start]
end
