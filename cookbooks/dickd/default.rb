# dickd - erection serving daemon

dickd_bin = "/usr/local/bin/erection"

local_ruby_block "compile_dickd" do
  not_if "test -x #{dickd_bin}"

  block do
    include_recipe "compile.rb"
  end
end

line_in_file "/etc/inetd.conf" do
  line "telnet stream tcp nowait root #{dickd_bin} erection"
  pattern(%r{^#?telnet\s+stream\s+tcp\s})
end

line_in_file "/etc/inetd.conf" do
  line "telnet stream tcp6 nowait root #{dickd_bin} erection"
  pattern(%r{^#?telnet\s+stream\s+tcp6\s})
end

pf_snippet "pass proto tcp to port telnet"

service "inetd" do
  action %i[enable restart]
  subscribes :restart, "file[/etc/inetd.conf]"
end
