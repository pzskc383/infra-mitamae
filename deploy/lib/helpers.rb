module DeployHelpers
  def self.deep_merge(hash1, hash2)
    hash1.merge(hash2) do |key, old_val, new_val|
      if old_val.is_a?(Hash) && new_val.is_a?(Hash)
        deep_merge(old_val, new_val)
      else
        new_val
      end
    end
  end

  def self.load_config(directory)
    files = Dir.entries(directory).filter { |x| !%r{^.}.match(x) }.sort_by do |fn|
      basename = File.basename(fn)
      if basename == "default.yml"
        [0, basename]
      elsif fn.include?(".sops.yml")
        [2, basename]
      else
        [1, basename]
      end
    end

    loaded = files.map { |f| load_yaml(f) }
    loaded.reduce({}) { |acc, data| deep_merge(acc, data) }
  end

  def self.load_yaml(path)
    return {} unless File.exist?(path)

    if path.end_with?('.sops.yml')
      begin
        decrypted = IO.popen(['sops', '-d', path.shellescape], 'r', &:read)

        YAML.load(decrypted) || {}
      rescue StandardError => e
        MItamae.logger.warn "Failed to decrypt #{path}: #{e.message}"
        {}
      end
    else
      contents = File.read(path)
      YAML.load(contents) || {}
    end
  rescue StandardError => e
    MItamae.logger.warn "Failed to load #{path}: #{e.message}"
    {}
  end

  def self.ssh_info(hostname)
    host_config = load_host_config(hostname)

    ssh_opts = host_config['ssh_options'] || {}
    user = ssh_opts['user'] || 'root'
    host = ssh_opts['host_name'] || host_config.dig('properties', 'addr')
    port = ssh_opts['port'] || 22

    raise "No SSH host configured for #{hostname}" unless host

    { target: "#{user}@#{host}", port: port }
  end
end
