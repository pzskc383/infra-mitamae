require 'bundler/setup'
require 'rake/testtask'
require 'yaml'

# Rake tasks for mitamae infrastructure management with hocho integration

# Test task setup (from example-ruby-git)
Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.test_files = Dir.glob('test/**/*.rb')
end

namespace :deploy do
  desc 'Deploy to all hosts'
  task :all do
    inventory = YAML.load_file('inventory/hosts.yaml')
    inventory['hosts'].each do |hostname, _config|
      Rake::Task['deploy:host'].invoke(hostname)
      Rake::Task['deploy:host'].reenable
    end
  end

  desc 'Deploy to specific host'
  task :host, [:hostname] do |_t, args|
    hostname = args[:hostname]
    raise 'Please specify hostname' unless hostname

    inventory = YAML.load_file('inventory/hosts.yaml')
    config = inventory['hosts'][hostname]
    raise "Host #{hostname} not found in inventory" unless config

    puts "Deploying to #{hostname}..."

    # Set environment variables for the recipe
    ENV.update({
                 'HOSTNAME' => hostname,
                 'DNS_ROLE' => config['dns_role'],
                 'MAIL_ROLE' => config['mail_role'],
                 'DNS_SHORTNAME' => config['dns_shortname'],
                 'MAIL_DOMAINS' => config['mail_domains'].join(','),
                 'TLS_CERTS_CONFIG' => config['tls_certs'].to_yaml,
                 'SECONDARY_HOSTS' => inventory['hosts'].select { |_h, c| c['dns_role'] == 'secondary' }.keys.join(',')
               })

    # Execute the orchestrator recipe
    cmd = "mitamae ssh --host #{hostname} recipes/orchestrator.rb --node-yaml inventory/hosts.yaml"
    puts "Running: #{cmd}"
    system(cmd) || raise("Deployment failed for #{hostname}")
  end

  desc 'Dry run on specific host'
  task :dry_run, [:hostname] do |_t, args|
    hostname = args[:hostname]
    raise 'Please specify hostname' unless hostname

    cmd = "mitamae ssh --host #{hostname} recipes/orchestrator.rb --node-yaml inventory/hosts.yaml --dry-run"
    puts "Running: #{cmd}"
    system(cmd) || raise("Dry run failed for #{hostname}")
  end
end

namespace :test do
  desc 'Test connectivity to all hosts'
  task :connectivity do
    inventory = YAML.load_file('inventory/hosts.yaml')
    inventory['hosts'].each do |hostname, config|
      puts "Testing connectivity to #{hostname}..."
      cmd = "ssh -p #{config['network']['ansible_port']} #{config['network']['ansible_user']}@#{config['network']['ansible_host']} 'echo Connected'"
      system(cmd) ? puts("✓ #{hostname} connected") : puts("✗ #{hostname} failed")
    end
  end

  desc 'Test specific service on host'
  task :service, [:hostname, :service] do |_t, args|
    hostname = args[:hostname]
    service = args[:service]
    raise 'Please specify hostname and service' unless hostname && service

    cmd = "mitamae ssh --host #{hostname} recipes/services/#{service}.rb --node-yaml inventory/hosts.yaml --dry-run"
    puts "Testing #{service} on #{hostname}..."
    system(cmd) || raise('Service test failed')
  end
end

namespace :secrets do
  desc 'Decrypt secrets using SOPS'
  task :decrypt do
    # Decrypt SOPS files for use in recipes
    sops_files = Dir.glob('../**/*.sops.yml')
    sops_files.each do |file|
      output = file.sub('.sops.yml', '.yml')
      cmd = "sops --decrypt #{file} > #{output}"
      puts "Decrypting #{file} -> #{output}"
      system(cmd) || puts("Failed to decrypt #{file}")
    end
  end

  desc 'Clean up decrypted files'
  task :clean do
    # Remove decrypted files
    decrypted_files = Dir.glob('../**/*.yml').select { |f| f.include?('.sops.') }
    decrypted_files.each do |file|
      puts "Removing #{file}"
      File.delete(file) if File.exist?(file)
    end
  end
end

namespace :hocho do
  desc 'List all hosts using hocho'
  task :list do
    puts "Listing hosts using hocho..."
    system('./bin/hocho list') || raise('Failed to list hosts')
  end

  desc 'Show host configuration using hocho'
  task :show, [:hostname] do |_t, args|
    hostname = args[:hostname]
    raise 'Please specify hostname' unless hostname

    puts "Showing configuration for #{hostname}..."
    system("./bin/hocho show #{hostname}") || raise("Failed to show #{hostname}")
  end

  desc 'Apply configuration to specific host using hocho'
  task :apply, [:hostname] do |_t, args|
    hostname = args[:hostname]
    raise 'Please specify hostname' unless hostname

    puts "Applying configuration to #{hostname} using hocho..."
    system("./bin/hocho apply #{hostname}") || raise("Failed to apply to #{hostname}")
  end

  desc 'Dry run configuration on specific host using hocho'
  task :dry_run, [:hostname] do |_t, args|
    hostname = args[:hostname]
    raise 'Please specify hostname' unless hostname

    puts "Dry run on #{hostname} using hocho..."
    system("./bin/hocho apply -n #{hostname}") || raise("Dry run failed for #{hostname}")
  end

  desc 'Apply configuration to all hosts using hocho'
  task :apply_all do
    inventory = YAML.load_file('inventory/hosts.yaml')
    inventory['hosts'].each do |hostname, _config|
      Rake::Task['hocho:apply'].invoke(hostname)
      Rake::Task['hocho:apply'].reenable
    end
  end

  desc 'Dry run on all hosts using hocho'
  task :dry_run_all do
    inventory = YAML.load_file('inventory/hosts.yaml')
    inventory['hosts'].each do |hostname, _config|
      Rake::Task['hocho:dry_run'].invoke(hostname)
      Rake::Task['hocho:dry_run'].reenable
    end
  end
end

namespace :vm do
  desc 'Build a fresh vm with packer'
  task :build do

  end
end

# Default task
task default: :test

begin
  require_relative '../rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end
