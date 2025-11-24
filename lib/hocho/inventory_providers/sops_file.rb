require "yaml"
require "open3"

require "hocho/inventory_providers/base"
require "hocho/host"
require "hocho/utils/symbolize"

module ::Hocho
  module InventoryProviders
    class SopsFile < Base
      def initialize(path:)
        @path = path
      end

      attr_reader :path

      def files
        Dir[::File.join(path, "*.sops.yml")]
      end

      def hosts
        @hosts ||= files.flat_map do |file|
          stdout, status = Open3.capture2("sops", "-d", file)
          raise "SOPS decryption error" unless status.success?

          content = Hocho::Utils::Symbolize.keys_of(YAML.load(stdout))

          content.reject { |name, _| name == :sops }.map do |name, value|
            properties = value[:properties] || {}
            # Prepend openbsd_patches to run_list for all hosts
            if properties[:run_list]
              properties[:run_list] = ["cookbooks/openbsd_patches/default.rb"] + properties[:run_list]
            end

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
    end
  end
end
