include_recipe 'defines.rb'

host "airstrip3" do
  attributes(
    dns_shortname: 'a2'
  )
end

host "f0rk" do
  attributes(
    dns_shortname: 'f0'
  )
end

# run_on "airstrip3" do
#   file "deploy/recipes/airstrip3.rb"
# end
# run_on "f0rk" do
# file "deploy/recipes/f0rk.rb"
# end
