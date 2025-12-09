package "go"

chroma_build_dir = "/root/chroma"

git "#{chroma_build_dir}" do
  repository "https://github.com/alecthomas/chroma.git"
  # revision "v2.20.0"
  depth 1
  not_if "test -x /var/www/bin/chroma"
end

execute "build chroma" do
  cwd "#{chroma_build_dir}/cmd/chroma"
  not_if "test -x #{chroma_build_dir}/cmd/chroma/chroma"
  command "go build"
end

execute "install chroma" do
  not_if "test -x /var/www/bin/chroma"
  command "install -m0755 -gbin -oroot #{chroma_build_dir}/cmd/chroma/chroma /var/www/bin/chroma"
end

# execute "cleanup chroma" do
#   only_if "test -d #{chroma_build_dir}"
#   command "rm -rf #{chroma_build_dir}"
# end