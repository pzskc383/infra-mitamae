module DeployHelpers
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

    loaded = files.map { |f| Hashie::Mash.new(load_yaml(f)) }
    loaded.reduce({}) { |acc, data| acc.merge!(acc, data) }
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

  def self.save_yaml(path, data)
    File.write(path, YAML.dump(data))
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

  def self.tmpdirname
    alphabet = [("0".."9"), ("a".."z"), ("A".."Z")].map(&:to_a).flatten
    randompart = (0..10).map { |_i| alphabet.sample }.join
    "/tmp/mitamae-run.#{randompart}"
  end
end
