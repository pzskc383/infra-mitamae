module ::MItamae
  module Plugin
    module Resource
      class LdapObject < ::MItamae::Resource::Base
        define_attribute :action, default: :create

        define_attribute :dn, type: String, default_name: true

        define_attribute :attrs, type: Hash, default: {}
        define_attribute :server, type: Hash, default: {
          host: "ldapi://%2fvar%2frun%2fldapi",
          root_dn: nil,
          bind_dn: nil,
          bind_secret: nil
        }

        self.available_actions = %i[create delete modify]

        def resource_type
          "ldap_object"
        end
      end
    end
  end
end
