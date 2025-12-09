remote_file "/usr/local/bin/ttycom0fix.sh" do
  source "files/ttycom0fix.sh"
  mode "0755"
  owner "root"
  group "bin"
end

file "/etc/boot.conf" do
  content <<~SNIPPET
    stty com0 115200
    set tty com0
  SNIPPET
end
