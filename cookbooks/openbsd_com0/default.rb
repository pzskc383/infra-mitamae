file "/etc/boot.conf" do
  action :create
  content <<~EOF
    stty com0 115200
    set tty com0
  EOF
end
