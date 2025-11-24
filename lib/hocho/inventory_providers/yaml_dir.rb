require "yaml"
require "open3"

module Hocho
  module InventoryProviders
    class YamlDir < Base
      VARS_DIR           = ::File.expand_path("../../vars", __dir__)
      DEFAULT_VARS_FILE  = File.join(VARS_DIR, "default.yml")
      SECRETS_SOPS_FILE  = File.join(VARS_DIR, "secrets.sops.yml")

      def initialize(path:)
        @path         = path
        @global_attrs = load_global_vars!
        super()
      end

      attr_reader :path

      def host_dirs
        Dir[File.join(@path, "/*/")]
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

            host_files = Dir[File.join(dir, "/**/*.yml")].sort_by do |fn|
              # 1) non‑default files first,
              # 2) sops files next,
              # 3) finally alphabetical
              [!fn.include?("default.yml"), fn.include?(".sops.yml"), fn].join("-")
            end

            value = host_files.map { |f| load_file(f) }.reduce({}) { |a, p| deep_merge(a, p) }

            [name, value]
          end

          hosts_data(loaded_hosts)

          loaded_hosts.map do |name, value|
            properties = value[:properties] || {}
            attributes = properties.fetch(:attributes, {})
            attributes ||= {}

            attributes.merge!(@global_attrs)
            properties[:attributes] = attributes

            properties[:attributes][:hosts]      = hosts
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
            raise "SOPS decryption error for #{filename}" unless status.success?

            YAML.safe_load(stdout).except(:sops)
          else
            YAML.load_file(filename)
          end

        Hocho::Utils::Symbolize.keys_of(data)
      end

      def hosts_data(loaded_hosts)
        data = {}

        loaded_hosts.each do |name, value|
          attrs  = value.dig(:properties, :attributes) || {}
          net    = attrs[:network_setup] || {}

          data[name] = {
            dns_shortname: attrs[:dns_shortname],
            v4: net.dig(:v4, :address),
            v6: net.dig(:v6, :address)
          }
        end

        first_attrs = loaded_hosts.values.first.dig(
          :properties,
          :attributes
        ) || {}
        ex1t_data = first_attrs[:hub]
        data["ex1t"] = {
          dns_shortname: ex1t_data[:dns_shortname],
          v4: ex1t_data[:v4],
          v6: ex1t_data[:v6]
        }

        data
      end

      private

      def load_global_vars!
        default_vars = YAML.load_file(DEFAULT_VARS_FILE)

        sops_stdout, sops_status = Open3.capture2("sops", "-d", SECRETS_SOPS_FILE)
        raise "Failed to decrypt #{SECRETS_SOPS_FILE}: #{sops_status}" unless sops_status.success?

        secret_vars = YAML.safe_load(sops_stdout)

        attrs = {}
        attrs.merge!(default_vars) if default_vars.is_a?(Hash)
        attrs.merge!(secret_vars)  if secret_vars.is_a?(Hash)

        # attrs[:sudo_command] = host.properties[:sudo_command] if host.properties[:sudo_command]

        attrs
      end
    end
  end
end
