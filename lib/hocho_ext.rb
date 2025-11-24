# Monkey-patches for hocho to support OpenBSD (sh instead of bash, configurable sudo)

require "hocho/drivers/mitamae"
require "hocho/drivers/ssh_base"

module HochoOpenBSDPatches
  module MitamaePatches
    # Override prepare_mitamae to use sh instead of bash
    def prepare_mitamae
      return if mitamae_available? && !mitamae_outdated?
      script = [*@mitamae_prepare_script].join("\n\n")
      if script.empty?
        raise "We have to prepare MItamae, but not mitamae_prepare_script is specified"
      end
      prepare_sudo do |sh, sudovars, sudocmd|
        log_prefix = "=> #{host.name} # "
        log_prefix_white = " " * log_prefix.size
        puts "#{log_prefix}#{script.each_line.map { |_| "#{log_prefix_white}#{_.chomp}" }.join("\n")}"

        ssh_run("sh") do |c|
          set_ssh_output_hook(c)

          c.send_data("cd #{host_basedir.shellescape}\n#{sudovars}\n#{sudocmd} sh <<-'HOCHOEOS'\n#{script}HOCHOEOS\n")
          c.eof!
        end
      end
      availability, outdated = mitamae_available?, mitamae_outdated?
      if !availability || outdated
        status = [availability ? nil : "unavailable", outdated ? "outdated" : nil].compact.join(" and ")
        raise "prepared MItamae, but it's still #{status}"
      end
    end

    # Override run_mitamae to use sh instead of bash
    def run_mitamae(dry_run: false)
      with_host_node_json_file do
        itamae_cmd = [@mitamae_path, "local", "-j", host_node_json_path, *@mitamae_options]
        itamae_cmd.push("--dry-run") if dry_run
        itamae_cmd.push(*run_list)

        prepare_sudo do |sh, sudovars, sudocmd|
          puts "=> #{host.name} # #{itamae_cmd.shelljoin}"
          ssh_run("sh") do |c|
            set_ssh_output_hook(c)

            c.send_data("cd #{host_basedir.shellescape}\n#{sudovars}\n#{sudocmd} #{itamae_cmd.shelljoin}\n")
            c.eof!
          end
        end
      end
    end
  end

  module SshBasePatches
    # Override to use sh instead of bash, doas instead of sudo, POSIX compatible
    def prepare_sudo(password = host.sudo_password)
      raise "sudo password not present" if host.sudo_required? && !host.nopasswd_sudo? && password.nil?

      unless host.sudo_required?
        yield nil, nil, ""
        return
      end

      sudo_cmd = host.properties[:sudo_command] || "doas"

      if host.nopasswd_sudo?
        yield nil, nil, "#{sudo_cmd} "
        return
      end

      passphrase_env_name = "HOCHO_PA_#{SecureRandom.hex(8).upcase}"

      temporary_passphrase = SecureRandom.base64(129).chomp

      local_supports_pbkdf2 = system(*%w[openssl enc -pbkdf2], in: File::NULL, out: File::NULL, err: [:child, :out])
      remote_supports_pbkdf2 = begin
        exitstatus, * = ssh_run("openssl enc -pbkdf2", error: false, &:eof!)
        exitstatus == 0
      end
      derive = (local_supports_pbkdf2 && remote_supports_pbkdf2) ? %w[-pbkdf2] : []

      encrypted_password = IO.pipe do |r, w|
        w.write temporary_passphrase
        w.close
        IO.popen(["openssl", "enc", "-aes-128-cbc", "-pass", "fd:5", "-a", "-md", "sha256", *derive, 5 => r], "r+") do |io|
          io.puts password
          io.close_write
          io.read.chomp
        end
      end

      begin
        tmpdir = host_shmdir ? "TMPDIR=#{host_shmdir.shellescape} " : nil
        temp_executable = ssh.exec!("#{tmpdir}mktemp").chomp
        raise unless temp_executable.start_with?("/")

        ssh_run("chmod 0700 #{temp_executable.shellescape}; cat > #{temp_executable.shellescape}; chmod +x #{temp_executable.shellescape}") do |ch|
          ch.send_data("#!/bin/sh\nexec openssl enc -aes-128-cbc -d -a -md sha256 #{derive.shelljoin} -pass env:#{passphrase_env_name} <<< #{encrypted_password.shellescape}\n")
          ch.eof!
        end

        askpass_env = (sudo_cmd == "doas") ? "DOAS_ASKPASS" : "SUDO_ASKPASS"
        sh = "#{passphrase_env_name}=#{temporary_passphrase.shellescape} #{askpass_env}=#{temp_executable.shellescape} #{sudo_cmd} -A "
        exp = "export #{passphrase_env_name}=#{temporary_passphrase.shellescape}\nexport #{askpass_env}=#{temp_executable.shellescape}\n"
        cmd = "#{sudo_cmd} -A "
        yield sh, exp, cmd
      ensure
        begin
          ssh_run("rm -f #{temp_executable.shellescape}")
        rescue
          nil
        end
      end
    end
  end
end

Hocho::Drivers::Mitamae.prepend(HochoOpenBSDPatches::MitamaePatches)
Hocho::Drivers::SshBase.prepend(HochoOpenBSDPatches::SshBasePatches)
