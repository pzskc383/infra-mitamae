require "bundler/setup"
require "hocho"

require 'cookstyle'
require 'rubocop/rake_task'
RuboCop::RakeTask.new(:cop) do |task|
  task.options << '--display-cop-names'
end

SOPS_FILES = [*Dir["./data/**/*.sops.yml"]].freeze

namespace :sops do
  desc "Decrypt secrets using SOPS"
  task :decrypt do
    SOPS_FILES.each do |file|
      cmd = "sops --decrypt -i #{file}"
      puts "Decrypting #{file}"
      system(cmd) || puts("Failed to decrypt #{file}")
    end
  end

  desc "Encrypt secrets using SOPS"
  task :encrypt do
    SOPS_FILES.each do |file|
      cmd = "sops --encrypt -i #{file}"
      puts "Encrypting #{file}"
      system(cmd) || puts("Failed to encrypt #{file}")
    end
  end
end
