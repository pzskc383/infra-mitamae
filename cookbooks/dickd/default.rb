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
  match_rx(/^#?telnet\s+stream\s+tcp\s/)
end

line_in_file "/etc/inetd.conf" do
  line "telnet stream tcp6 nowait root #{dickd_bin} erection"
  match_rx(/^#?telnet\s+stream\s+tcp6\s/)
end

pf_snippet "dickd" do
  content "pass proto tcp to port telnet"
end

service "inetd" do
  action [:enable, :restart]
  subscribes :edit, "file[/etc/inetd.conf]"
end
