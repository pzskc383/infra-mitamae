# frozen_string_literal: true

require 'bundler/setup'
require 'hocho'

namespace :secrets do
  desc 'Decrypt secrets using SOPS'
  task :decrypt do
    sops_files = ['hocho.yml', 'hosts.yml']
    sops_files.each do |file|
      cmd = "sops --decrypt -i #{file}"
      puts "Decrypting #{file}"
      system(cmd) || puts("Failed to decrypt #{file}")
    end
  end

  desc 'Encrypt secrets using SOPS'
  task :encrypt do
    sops_files = ['hocho.yml', 'hosts.yml']
    sops_files.each do |file|
      cmd = "sops --encrypt -i #{file}"
      puts "Decrypting #{file}"
      system(cmd) || puts("Failed to decrypt #{file}")
    end
  end
end

namespace :hocho do
  desc 'List all hosts using hocho'
  task :list do
    puts 'Listing hosts using hocho...'
    system('hocho list') || raise('Failed to list hosts')
  end
end
