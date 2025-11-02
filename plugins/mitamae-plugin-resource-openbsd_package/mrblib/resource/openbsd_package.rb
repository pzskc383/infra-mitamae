class ::MItamae::Plugin::Resource::OpenBSDPackage < ::MItamae::Resource::Base
  define_attribute :action, default: :install
  self.available_actions = [:install, :remove]

  define_attribute :name, type: String, default_name: true

  define_attribute :version, type: String
  define_attribute :flavor, type: String
  define_attribute :branch, type: String
end
