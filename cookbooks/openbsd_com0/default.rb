file "/etc/boot.conf" do
  content <<~SNIPPET
    stty com0 115200
    set tty com0
  SNIPPET
end
