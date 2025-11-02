# frozen_string_literal: true

module ::MItamae
  module Plugin
    module ResourceExecutor
      class OpenBSDPackage < ::MItamae::ResourceExecutor::Base
        VERSION_RE = %r{\A
          (?<name>
            [a-z0-9-]*[a-z0-9]
          )-
          (?<version>
            [0-9.]+
            (?:(?:rc|alpha|beta|pre|pl|p)[0-9]+)?
          )
          (?<flavor>
            (?<=-)
            [a-z0-9_-]+
          )?
        \Z}x

        FUZZY_RE = %r{\A
            (?<name>
              [a-z0-9-]+[a-z0-9]
            )--
            (?<flavor>
              [a-z0-9_]+
            )?
            (?<branch>
              (?<=%)
              [a-z0-9_-]+
            )?
          \Z}x

        def apply
          if desired.installed && !current.installed
            install_package(desired)
          elsif !desired.installed && current.installed
            delete_package(current.name)
          elsif attributes_changed?
            delete_package(current.name)
            install_package(desired)
          end
        end

        private

        def attributes_changed?
          %(version branch flavor).any? do |m|
            current.send(m) != desired.send(m)
          end
        end

        def set_current_attributes(current, _action)
          installed_info = installed_info(attributes.name)

          current.installed = !installed_info.nil?
          %w[version branch flavor].each do |k|
            current.send("#{k}=", installed_info.fetch(k))
          end
        end

        def set_desired_attributes(desired, action)
          case action
          when :install
            desired.installed = true
          when :remove
            desired.installed = false
          end
        end

        def installed_info(pkg_name)
          info = { name: pkg_name }
          fuzzy_check_result = run_command(['pkg_info', '-qze', "#{pkg_name}-*"])

          fm = fuzzy_re.match(fuzzy_check_result.stdout.lines.first.chomp)

          info[:flavor] = fm[:flavor] if fm[:flavor]
          info[:branch] = fm[:branch] if fm[:branch]
          info[:version] = get_version(pkg_name)

          info
        rescue Error
          nil
        end

        def get_version(pkg_name)
          version_result = run_command(['pkg_info', '-qSe', "#{pkg_name}-*"])

          raise RuntimeError('Invalid version check result!') if version_result.exit_status != 0

          vm = version_re.match(version_result.stdout.lines.first.chomp)

          raise RuntimeError("Can't find version in version check output!") if !vm || !vm.has?(:version)

          vm[:version]
        end

        def delete_package(pkg_name)
          run_command(['pkg_delete', pkg_name])
        end

        def install_package(info)
          raise RuntimeError('Specify either branch or version') if info.version && info.branch

          version = info.version or ''
          pkg_name = "#{info.name}-#{version}-"
          pkg_name = "#{pkg_name}#{flavor}" if flavor
          pkg_name = "#{pkg_name}%#{branch}" if branch && info.version.nil?

          run_command(['pkg_add', pkg_name])
        end
      end
    end
  end
end
