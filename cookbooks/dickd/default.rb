# dickd - erection serving daemon
dickd_bin = "/usr/local/bin/erection"
dickd_builddir = "/tmp/dickd-build"

has_dickd = run_command("test -x #{dickd_bin}").exit_status == 0

directory dickd_builddir do
  not_if { has_dickd }
end

%w[erection.c frames.h].each do |f|
  remote_file "#{dickd_builddir}/#{f}" do
    not_if { has_dickd }
  end
end

execute "compile erection" do
  command "cc -o #{dickd_bin} #{dickd_builddir}/erection.c"
  not_if { has_dickd }
end

directory dickd_builddir do
  action :delete
  not_if { has_dickd }
end

file "/etc/inetd.conf" do
  action :edit
  block do |data|
    data.gsub(%r[^telnet.*$], '')
    <<-EOF
      #{data}
      telnet stream  tcp  nowait nobody  #{dickd_bin}  erection
      telnet stream  tcp6 nowait nobody  #{dickd_bin}  erection
    EOF
  end
end

pf_snippet "pass proto tcp to port telnet"

service "inetd" do
  action %i[enable start]
end
