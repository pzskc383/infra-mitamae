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
      end

      attr_reader :path

      def host_dirs
        Dir[::File.join(path, "/*/")]
      end

      def deep_merge(h1, h2)
        h1.merge(h2) do |_key, v1, v2|
          if v1.is_a?(Hash) && v2.is_a?(Hash)
            deep_merge(v1, v2)
          else
            v2
          end
        end
      end

      def hosts
        @hosts ||= host_dirs.flat_map do |dir|
          name = File.basename(dir)

          host_files = Dir[::File.join(dir, "/**/*.yml")].sort_by do |fn|
            [!fn.include?("default.yml"), fn.include?(".sops.yml")].join("-")
          end

          value = host_files.map do |f|
            if f.include?(".sops.yml")
              load_sops_yaml(f)
            else
              load_plain_yaml(f)
            end
          end.reduce({}) do |a, p|
            deep_merge(a, p)
          end

          properties = value[:properties] || {}

          Host.new(
            name.to_s,
            providers: self.class,
            properties: properties,
            tags: value[:tags] || {},
            ssh_options: value[:ssh_options]
          )
        end
      end

      def load_sops_yaml(file)
        stdout, status = Open3.capture2("sops", "-d", file)
        raise "SOPS decryption error" unless status.success?

        content = Hocho::Utils::Symbolize.keys_of(YAML.safe_load(stdout))

        content.except(:sops)
      end

      def load_plain_yaml(file)
        Hocho::Utils::Symbolize.keys_of(YAML.load_file(file))
      end
    end
  end
end
