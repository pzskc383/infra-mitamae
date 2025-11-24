require "yaml"
require "open3"

require "hocho/inventory_providers/base"
require "hocho/host"
require "hocho/utils/symbolize"

module ::Hocho
  module InventoryProviders
    class YamlDir < Base
      def initialize(path:)
        @path = path
        super
      end

      attr_reader :path

      def host_dirs
        Dir[::File.join(path, "/*/")]
      end

      def deep_merge(hash1, hash2)
        hash1.merge(hash2) do |_key, v1, v2|
          if v1.is_a?(Hash) && v2.is_a?(Hash)
            deep_merge(v1, v2)
          else
            v2
          end
        end
      end

      def hosts
        @hosts ||= begin
          loaded_hosts = host_dirs.to_h do |dir|
            name = File.basename(dir)

            host_files = Dir[::File.join(dir, "/**/*.yml")].sort_by do |fn|
              [!fn.include?("default.yml"), fn.include?(".sops.yml")].join("-")
            end

            value = host_files.map { |f| load_file(f) }.reduce({}) { |a, p| deep_merge(a, p) }

            [name, value]
          end

          loaded_hosts.map do |name, value|
            properties = value[:properties] || {}
            properties[:attributes] ||= {}
            properties[:attributes][:hosts] = hosts_data(loaded_hosts)
            properties[:attributes][:hocho_host] = name

            Host.new(
              name.to_s,
              providers: self.class,
              properties: properties,
              tags: value[:tags] || {},
              ssh_options: value[:ssh_options]
            )
          end
        end
      end

      def load_file(filename)
        data =
          if filename.include?(".sops.yml")
            stdout, status = Open3.capture2("sops", "-d", filename)
            raise "SOPS decryption error" unless status.success?

            YAML.safe_load(stdout).except(:sops)
          else
            YAML.load_file(filename)
          end

        Hocho::Utils::Symbolize.keys_of(data)
      end

      def hosts_data(loaded_hosts)
        data = {}
        loaded_hosts.each do |name, value|
          attrs = value.dig(:properties, :attributes) || {}
          net = attrs[:network_setup] || {}
          data[name] = {
            dns_shortname: attrs[:dns_shortname],
            v4: net.dig(:v4, :address),
            v6: net.dig(:v6, :address)
          }
        end

        ex1t_data = loaded_hosts.values.first.dig(:properties, :attributes, :hub)
        data["ex1t"] = {
          dns_shortname: ex1t_data[:dns_shortname],
          v4: ex1t_data[:v4],
          v6: ex1t_data[:v6]
        }

        data
      end
    end
  end
end
