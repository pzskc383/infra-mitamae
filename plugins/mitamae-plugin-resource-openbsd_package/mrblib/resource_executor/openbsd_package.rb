class ::MItamae::Plugin::ResourceExecutor::OpenBSDPackage < ::MItamae::ResourceExecutor::Base
  def apply
    if desired.installed and !current.installed
      install_package(desired)
    elsif !desired.installed and current.installed
      delete_package(current.name)
    else
      attributes_differ = %{version branch flavor}.any? do |m|
        current.send(m) != desired.send(m)
      end

      if attributes_differ
        delete_package(current.name)
        install_package(desired)
      end
    end
  end

  private

  def set_current_attributes(current, action)
    installed_info = installed_info(attributes.name)

    if installed_info
      current.installed = true
      current.version = installed_info[:version]
      current.branch = installed_info[:branch]
      current.flavor = installed_info[:flavor]
    else
      current.installed = false
      current.version = nil
      current.branch = nil
      current.flavor = nil
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
    info = {name: pkg_name}
    fuzzy_check_result = run_command(['pkg_info', '-qze', "#{pkg_name}-*"])

    fuzzy_re = %r[\A
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
    \Z]x

    fm = fuzzy_re.match(fuzzy_check_result.stdout.lines.first.chomp)

    if fm[:flavor]
      info[:flavor] = fm[:flavor]
    end

    if fm[:branch]
      info[:branch] = fm[:branch]
    else
      info[:version] = get_version(pkg_name)
    end

    info
  end

  def get_version(pkg_name)
    version_re = %r[\A
      (?<name>
        [a-z0-9-]*[a-z0-9]
      )-
      (?<version>
        [0-9.]+
        (?:(rc|alpha|beta|pre|pl|p)[0-9]+)?
      )
      (?<flavor>
        (?<=-)
        [a-z0-9_-]+
      )?
    \Z]x

    version_result = run_command(['pkg_info', '-qSe', "#{pkg_name}-*"])

    if version_result.exit_status != 0
      raise RuntimeError("Invalid version check result!")
    end

    vm = version_re.match(version_line)

    if !vm or !vm.has?(:version)
      raise RuntimeError("Can't find version in version check output!")
    end
    
    vm[:version]
  end

  def delete_package(pkg_name)
    run_command(['pkg_delete', pkg_name])
  end

  def install_package(info)
    name = info.name

    if info.version and info.branch 
      raise RuntimeError("Specify either branch or version")
    end

    if info.version
      pkg_name = "#{info.name}-#{info.version}"
      pkg_name = "#{pkg_name}#{flavor}" if flavor

    else
      pkg_name = "#{name}--"
      pkg_name = "#{pkg_name}#{flavor}" if flavor
      pkg_name = "#{pkg_name}%#{branch}" if branch
    end

    run_command(['pkg_add', pkg_name])
  end
end
