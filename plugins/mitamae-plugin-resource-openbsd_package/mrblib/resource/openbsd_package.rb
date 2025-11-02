# frozen_string_literal: true

module ::MItamae
  module Plugin
    module Resource
      class OpenBSDPackage < ::MItamae::Resource::Base
        define_attribute :action, default: :install
        self.available_actions = %i[install remove]

        define_attribute :name, type: String, default_name: true

        define_attribute :version, type: String
        define_attribute :flavor, type: String
        define_attribute :branch, type: String

        def resource_type
          @resource_type ||= 'openbsd_package'
        end
      end
    end
  end
end
