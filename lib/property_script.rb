#!/usr/bin/env ruby
# Property provider script: loads default vars and decrypted secrets into host.properties[:attributes]
# This runs LOCALLY on your machine during `hocho apply`

require "yaml"
require "open3"

default_vars = YAML.load_file("./vars/default.yml")

sops_stdout, sops_status = Open3.capture2("sops", "-d", "./vars/secrets.sops.yml")
raise "Failed to decrypt secrets.sops.yml: #{sops_status}" unless sops_status.success?
default_secret_vars = YAML.load(sops_stdout)

# Inject into host attributes (will be sent to node.json on remote host)
host.properties[:attributes] ||= {}
host.properties[:attributes].merge!(default_vars)
host.properties[:attributes].merge!(default_secret_vars)
