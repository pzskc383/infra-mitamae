dickd_bin = "/usr/local/bin/erection"
dickd_builddir = "/tmp/dickd-build"

directory dickd_builddir

%w[erection.c frames.h].each do |f|
  remote_file "#{dickd_builddir}/#{f}"
end

execute "compile erection" do
  command "cc -o #{dickd_bin} #{dickd_builddir}/erection.c"
end

directory dickd_builddir do
  action :delete
  only_if "test -d #{dickd_builddir}"
end
