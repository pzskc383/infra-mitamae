# Main deployment orchestration
#
# Usage:
#   rake sops:decrypt                    # Decrypt secrets first
#   mitamae local deploy/default.rb      # Deploy all hosts
#   mitamae local --dry-run deploy/default.rb  # Dry run
#
# To deploy a single host, comment out the others or create a separate file

include_recipe 'defines.rb'

# Define hosts
# SSH targets are loaded from data/hosts/*/secrets.sops.yml
# Make sure to run `rake sops:decrypt` first!

host "airstrip1" do
  attributes(
    dns_shortname: 'a1'
  )
end

host "a2mm" do
  ssh nil  # Will be loaded from secrets
  attributes(
    dns_shortname: 'a2'
  )
end

host "b0rsch" do
  ssh nil  # Will be loaded from secrets
  attributes(
    dns_shortname: 'b0'
  )
end

host "f0rk" do
  ssh nil  # Will be loaded from secrets
  attributes(
    dns_shortname: 'f0'
  )
end

# Deploy to all hosts
# Uncomment the hosts you want to deploy to

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

# Example: Deploy with custom attributes
# run_on "airstrip1", file: "deploy/recipes/airstrip1.rb", attributes: {
#   custom_var: "value"
# }
