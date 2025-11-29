module DeployHelpers
  # Deep merge hashes
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
    files = Dir.entries(directory).filter {|x| !%r[^.].match(x)}.sort_by do |fn|
      basename = File.basename(fn)
      if basename == "default.yml"
        [0, basename]
      elsif fn.include?(".sops.yml")
        [2, basename]
      else
        [1, basename]
      end
    end

    loaded = files.map { |f| self.load_yaml(f) }
    merged = loaded.reduce({}) { |acc, data| self.deep_merge(acc, data) }
    merged
  end

  # Load YAML file (handles both encrypted and decrypted)
  def self.load_yaml(path)
    return {} unless File.exist?(path)

    # If it's a .sops.yml file, decrypt on-the-fly
    if path.end_with?('.sops.yml')
      begin
        decrypted = `sops -d #{path.shellescape} 2>/dev/null`
        return {} if $?.exitstatus != 0
        YAML.load(decrypted) || {}
      rescue => e
        MItamae.logger.warn "Failed to decrypt #{path}: #{e.message}"
        return {}
      end
    else
      YAML.load(File.read(path)) || {}
    end
  rescue => e
    MItamae.logger.warn "Failed to load #{path}: #{e.message}"
    {}
  end


  # Get SSH connection info for host
  # Returns hash with :target (user@host) and :port
  def self.ssh_info(hostname)
    host_config = load_host_config(hostname)

    # Try to get from registered host first
    registered = get_host(hostname) rescue nil
    if registered && registered[:ssh]
      # Parse user@host:port or user@host format
      if registered[:ssh] =~ /^(.+@.+?):(\d+)$/
        return { target: $1, port: $2.to_i }
      else
        return { target: registered[:ssh], port: 22 }
      end
    end

    # Fall back to config
    ssh_opts = host_config.dig('ssh_options') || {}
    user = ssh_opts['user'] || 'root'
    host = ssh_opts['host_name'] || host_config.dig('properties', 'addr')
    port = ssh_opts['port'] || 22

    raise "No SSH host configured for #{hostname}" unless host

    { target: "#{user}@#{host}", port: port }
  end
end
