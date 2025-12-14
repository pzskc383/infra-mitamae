include_recipe 'helpers'

define :host, ssh: nil, attributes: {} do
  host = params[:name]
  globals = DeployHelpers.load_config("./data/vars")
  host_config = DeployHelpers.load_config("./data/hosts/#{host}")

  attrs = ::Hashie::Mash.new({ properties: { attributes: globals } })
  attrs.merge!(host_config)
  attrs.properties.attributes.merge! params[:attributes]

  node[:hosts] ||= {}
  node[:hosts][params[:name]] = attrs
end

define :run_on, file: nil, attributes: {}, dry_run: false do
  hostname = params[:name]
  recipe_file = params[:file]
  extra_attributes = params[:attributes]

  raise "Recipe file required for run_on" unless recipe_file
  raise "Recipe file does not exist: #{recipe_file}" unless File.exist?(recipe_file)

  host_config = node[:hosts][hostname]
  host_config[:properties][:attributes].merge!(extra_attributes)

  deploy_dir = "./tmp/deploy-#{hostname}"
  recipe_basename = File.basename(recipe_file)

  execute "create_deploy_dir_#{hostname}" do
    command "rm -rf #{deploy_dir} && mkdir -p #{deploy_dir}/bin #{deploy_dir}/recipes"
    user nil
  end

  execute "copy_cookbooks_#{hostname}" do
    command "cp -r cookbooks plugins lib #{deploy_dir}/"
    user nil
  end

  execute "copy_mitamae_#{hostname}" do
    command "cp dist/mitamae-*-openbsd #{deploy_dir}/bin/mitamae && chmod +x #{deploy_dir}/bin/mitamae"
    user nil
  end

  execute "copy_recipe_#{hostname}" do
    command "cp #{recipe_file} #{deploy_dir}/recipes/#{recipe_basename}"
    user nil
  end

  # Generate and write node.yaml
  file "#{deploy_dir}/node.yaml" do
    content YAML.dump(all_attributes)
  end

  ssh_info = host_config[:ssh_options]

  ssh_target = ssh_info[:target] || "#{ssh_info[:user]}@#{ssh_info[:host_name]}"
  ssh_port = ssh_info[:port] || 22
  remote_path = DeployHelpers.tmpdirname

  ssh_opts = ssh_port != 22 && ssh_info[:target].nil? ? "-p #{ssh_port}" : ""
  scp_opts = ssh_port != 22 && ssh_info[:target].nil? ? "-P #{ssh_port}" : ""

  execute "scp_to_#{hostname}" do
    command "scp #{scp_opts} -r #{deploy_dir}/ #{ssh_target}:#{remote_path}"
    user nil
  end

  dry_run = params[:dry_run] ? "-n" : ""

  mitamae_cmd = [
    "cd #{remote_path}",
    "&&",
    "./bin/mitamae local -y node.yaml #{dry_run}",
    "lib/mitamae_ext.rb",
    "lib/mitamae_defines.rb",
    "recipes/#{recipe_basename}"
  ].join(' ')

  execute "deploy_#{hostname}" do
    command "ssh #{ssh_opts} #{ssh_target} '#{mitamae_cmd}'"
    user nil
  end

  execute "cleanup_remote_#{hostname}" do
    command "ssh #{ssh_opts} #{ssh_target} 'rm -rf #{remote_path}' || true"
    user nil
  end

  execute "cleanup_local_#{hostname}" do
    command "rm -rf #{deploy_dir}"
    user nil
  end
end
