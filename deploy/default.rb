include_recipe 'defines.rb'
host "airstrip1" do
  attributes(
    dns_shortname: 'a1'
  )
end

host "a2mm" do
  attributes(
    dns_shortname: 'a2'
  )
end

host "b0rsch" do
  attributes(
    dns_shortname: 'b0'
  )
end

host "f0rk" do
  attributes(
    dns_shortname: 'f0'
  )
end

# run_on "airstrip1" do
#   file "deploy/recipes/airstrip1.rb"
# end
# run_on "a2mm" do
#   file "deploy/recipes/a2mm.rb"
# end
run_on "b0rsch" do
  file "deploy/recipes/b0rsch.rb"
end
# run_on "f0rk" do
# file "deploy/recipes/f0rk.rb"
# end
