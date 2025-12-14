include_recipe 'defines.rb'

host "a2mm" do
  attributes(
    dns_shortname: 'a2'
  )
end

host "f0rk" do
  attributes(
    dns_shortname: 'f0'
  )
end

# run_on "a2mm" do
#   file "deploy/recipes/a2mm.rb"
# end
# run_on "f0rk" do
# file "deploy/recipes/f0rk.rb"
# end
