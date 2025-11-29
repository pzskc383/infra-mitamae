include_recipe 'lib/helpers'



define :host, ssh: nil, attributes: {} do
  host = params[:name]
  globals = DeployHelpers.load_config("./data/vars")
  host_config = DeployHelpers.load_config("./data/hosts/#{host}")

  attrs = [
    { properties: { attributes: globals } },
    host_config, 
    { properties: { attributes: params[:attributes] } }
  ].reduce({}) do |a,x|
    DeployHelpers.deep_merge(a,x)
  end
  
  node[:hosts] ||= {}
  node[:hosts][params[:name]] = attrs
end

define :run_on, file: nil, attributes: {}, dry_run: false do
  hostname = params[:name]
  recipe_file = params[:file]
  extra_attributes = params[:attributes]
  dry_run = params[:dry_run]

  raise "Recipe file required for run_on" unless recipe_file
  raise "Recipe file does not exist: #{recipe_file}" unless File.exist?(recipe_file)

  host_config = node[:hosts][hostname]

  all_attributes = DeployHelpers.deep_merge(
    host_config[:attributes] || {},
    extra_attributes
  )

  # Generate node.json
  node_data = DeployHelpers.generate_node_json(hostname, all_attributes)

  # Create temp deploy directory name
  deploy_dir = "/tmp/mitamae-local-deploy-#{hostname}"
  recipe_basename = File.basename(recipe_file)

  # Create deploy directory structure
  execute "create_deploy_dir_#{hostname}" do
    command "rm -rf #{deploy_dir} && mkdir -p #{deploy_dir}/bin #{deploy_dir}/recipes"
    user nil
  end

  # Copy directory structure
  execute "copy_cookbooks_#{hostname}" do
    command "cp -r cookbooks plugins lib #{deploy_dir}/"
    user nil
  end

  # Copy mitamae binary
  execute "copy_mitamae_#{hostname}" do
    command "cp dist/mitamae-*-openbsd #{deploy_dir}/bin/mitamae && chmod +x #{deploy_dir}/bin/mitamae"
    user nil
  end

  # Copy recipe file
  execute "copy_recipe_#{hostname}" do
    command "cp #{recipe_file} #{deploy_dir}/recipes/#{recipe_basename}"
    user nil
  end

  # Generate and write node.json
  file "#{deploy_dir}/node.yaml" do
    content YAML.dump(node_data)
  end

  # Get SSH connection info
  ssh_info = if host_config[:ssh_options]
    # Parse inline SSH string
    if host_config[:ssh] =~ /^(.+@.+?):(\d+)$/
      { target: $1, port: $2.to_i }
    else
      { target: host_config[:ssh], port: 22 }
    end
  else
    DeployHelpers.ssh_info(hostname)
  end

  ssh_target = ssh_info[:target]
  ssh_port = ssh_info[:port]
  remote_path = "/tmp/mitamae-deploy-#{hostname}"

  # Build SSH/SCP options
  ssh_opts = ssh_port != 22 ? "-p #{ssh_port}" : ""
  scp_opts = ssh_port != 22 ? "-P #{ssh_port}" : ""

  # Upload deploy directory
  execute "scp_to_#{hostname}" do
    command "scp #{scp_opts} -r #{deploy_dir}/ #{ssh_target}:#{remote_path}"
    user nil
  end

  # Run mitamae on remote host
  mitamae_cmd = [
    "cd #{remote_path}",
    "&&",
    "./bin/mitamae local -j node.json",
    "lib/mitamae_ext.rb",
    "lib/mitamae_defines.rb",
    "recipes/#{recipe_basename}"
  ].join(' ')

  execute "deploy_#{hostname}" do
    command "ssh #{ssh_opts} #{ssh_target} '#{mitamae_cmd}'"
    user nil
  end

  # Cleanup remote
  execute "cleanup_remote_#{hostname}" do
    command "ssh #{ssh_opts} #{ssh_target} 'rm -rf #{remote_path}' || true"
    user nil
  end

  # Cleanup local
  execute "cleanup_local_#{hostname}" do
    command "rm -rf #{deploy_dir}"
    user nil
  end
end
