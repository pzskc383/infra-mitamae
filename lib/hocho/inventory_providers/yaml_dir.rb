require 'yaml'
require 'open3'
require 'hocho/utils/symbolize'
require 'hocho/inventory_providers/base'
require 'hocho/host'

module Hocho
  module InventoryProviders
    class YamlDir < Base
      def initialize(path:)
        @path = path
        @vars_dir = File.join(File.dirname(@path), "vars")
        @global_attrs = load_global_vars!
        super()
      end

      attr_reader :path

      # Helper: Load a single file (bare or SOPS-encrypted)
      def load_file(filename)
        data =
          if filename.include?(".sops.yml")
            stdout, status = Open3.capture2("sops", "-d", filename)
            raise "SOPS decryption error for #{filename}" unless status.success?

            YAML.safe_load(stdout).except(:sops)
          else
            YAML.load_file(filename)
          end

        Hocho::Utils::Symbolize.keys_of(data)
      end

      # Helper: Load all YAML files from a directory with correct ordering
      # Order: default.yml first, other non-sops files, then .sops.yml files
      def load_dir_vars(path)
        files = Dir[File.join(path, "*.yml")].sort_by do |fn|
          basename = File.basename(fn)
          if basename == "default.yml"
            [0, basename]  # Load first
          elsif fn.include?(".sops.yml")
            [2, basename]  # Load last
          else
            [1, basename]  # Load middle
          end
        end

        files.map { |f| load_file(f) }.reduce({}) { |acc, data| deep_merge(acc, data) }
      end

      # Deep merge helper
      def deep_merge(hash1, hash2)
        hash1.merge(hash2) { |_k, v1, v2| v1.is_a?(Hash) && v2.is_a?(Hash) ? deep_merge(v1, v2) : v2 }
      end

      # Build hosts data structure with network info
      def build_hosts_data(loaded_hosts)
        data = {}

        # Add all registered hosts
        loaded_hosts.each do |name, value|
          attrs = value.dig(:properties, :attributes) || {}
          net = attrs[:network_setup] || {}
          data[name] = {
            dns_shortname: attrs[:dns_shortname],
            v4: net.dig(:v4, :address),
            v6: net.dig(:v6, :address)
          }
        end

        # Add hub host from global attributes
        if @global_attrs[:hub]
          data[:hub] = {
            dns_shortname: @global_attrs[:hub][:dns_shortname],
            v4: @global_attrs[:hub][:v4],
            v6: @global_attrs[:hub][:v6]
          }
        end

        data
      end

      def hosts
        @hosts ||= begin
          # Load all hosts from directories
          host_dirs = Dir[File.join(@path, "*/")]
          loaded_hosts = host_dirs.to_h do |dir|
            name = File.basename(dir)
            value = load_dir_vars(dir)
            [name, value]
          end

          # Build the hosts data structure
          hosts_data = build_hosts_data(loaded_hosts)

          # Create Host objects
          loaded_hosts.map do |name, value|
            props = value[:properties] || {}
            attrs = props.fetch(:attributes, {}).dup

            # Merge global attributes
            attrs.merge!(@global_attrs)

            # Inject hosts data and current host name
            attrs[:hosts] = hosts_data
            attrs[:hocho_host] = name

            props[:attributes] = attrs

            Host.new(
              name.to_s,
              providers: self.class,
              properties: props,
              tags: value[:tags] || {},
              ssh_options: value[:ssh_options]
            )
          end
        end
      end

      private

      def load_global_vars!
        load_dir_vars(@vars_dir)
      end
    end
  end
end
