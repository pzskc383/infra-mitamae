module ::MItamae
  module Plugin
    module ResourceExecutor
      class LdapObject < ::MItamae::ResourceExecutor::Base
        def set_current_attributes(current, _action)
          current.exists = exists_on_server?(attributes.server, attributes.dn)
        end

        def set_desired_attributes(desired, action)
          case action
          when :create, :modify
            desired.exists = true
          when :remove
            desired.exists = false
          end
        end

        def apply
          if current.exists && !desired.exists
            action = :delete
          elsif !current.exists && desired.exists
            action = :add
          elsif current.exists && desired.exists
            action = :modify
          end
          ldap_cmd(action, desired.server, desired.dn, desired.attrs) unless action.nil?
        end

        private

        def ldap_cmd(action, server, name, attrs)
          case action
          when :add
            cmdbase = "ldapadd"
            ldif = build_add_ldif(name, attrs)
          when :modify
            cmdbase = "ldapmodify"
            ldif = build_mod_ldif(name, attrs)
          when :delete
            cmdbase = "ldapmodify"
            ldif = build_del_ldif(name)
          end

          ldap_mod_cmd = Shellwords.join([
                                           cmdbase,
                                           "-H", server.host,
                                           "-D", server.bind_dn,
                                           "-w", server.bind_secret
                                         ])
          ::MItamae.logger.info ldap_mod_cmd.inspect

          IO.popen(ldap_mod_cmd, 'r+') do |io|
            ::MItamae.logger.info "writing LDIF"
            io.write(ldif)
            io.close_write
            ::MItamae.logger.info "Sent LDIF:"
            ::MItamae.logger.info ldif
            ::MItamae.logger.info "Got Output:"
            ::MItamae.logger.info io.readlines
            io.close
          end

          exit_status = wait_thr.value
          if exit_status.success?
            ::MItamae.logger.info "LDAP operation completed successfully"
          else
            error_output = stderr.read
            raise "LDAP operation failed with exit status #{exit_status.exitstatus}: #{error_output}"
          end

          stdout.read
        end

        def build_add_ldif(name, attrs)
          ldif_lines = ["dn: #{name}"]
          attrs.each do |k, a|
            case a
            when Array
              a.each { |aa| ldif_lines << "#{k}: #{aa}" }
            when String
              ldif_lines << "#{k}: #{a}"
            end
          end
          ldif_lines.join("\n")
        end

        def build_del_ldif(name)
          <<~EOLDIF
            dn: #{name}
            changetype: delete
          EOLDIF
        end

        def build_mod_ldif(name, attrs)
          ldif_lines = ["dn: #{name}", "changetype: modify"]

          attrs.each do |attr, values|
            ldif_lines << "replace: #{attr}"
            values = [values] if values.is_a? String
            values.each do |v|
              ldif_lines << "#{attr}: #{v}"
            end
            ldif_lines << "-"
          end

          ldif_lines.join("\n")
        end

        def exists_on_server?(server, name)
          base_dn = server.root_dn
          identifier, search_base = name.split(',')
          search_base = base_dn if search_base.length < base_dn.length

          ldap_search_cmd = [
            "ldap", "search",
            "-H", server.host,
            "-b", search_base,
            "-D", server.bind_dn,
            "-w", server.bind_secret,
            "'(#{identifier})'",
            "|", "wc", "-l"
          ].join(' ')

          object_check_result = run_command(ldap_search_cmd)

          object_check_result.stdout.chomp!.to_i > 0
        end
      end
    end
  end
end
