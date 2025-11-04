require "yaml"
require "open3"
require "hocho/inventory_providers/base"
require "hocho/host"
require "hocho/utils/symbolize"

module Hocho
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
            Host.new(
              name.to_s,
              providers: self.class,
              properties: value[:properties] || {},
              tags: value[:tags] || {},
              ssh_options: value[:ssh_options]
            )
          end
        end
      end
    end
  end
end
