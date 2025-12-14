# Monkey-patches for hocho to support OpenBSD (sh instead of bash, configurable sudo)
#
require "hocho/drivers/mitamae"
require "hocho/drivers/ssh_base"

module HochoOpenBSDPatches
  module MitamaePatches
    def prepare_mitamae
      return if mitamae_available? && !mitamae_outdated?

      script = [*@mitamae_prepare_script].join("\n\n")
      raise "We have to prepare MItamae, but not mitamae_prepare_script is specified" if script.empty?

      prepare_sudo do |_sh, sudovars, sudocmd|
        log_prefix = "=> #{host.name} # "
        log_prefix_white = " " * log_prefix.size
        puts "#{log_prefix}#{script.each_line.map { |l| "#{log_prefix_white}#{l.chomp}" }.join("\n")}"

        ssh_run("sh") do |c|
          set_ssh_output_hook(c)

          c.send_data("cd #{host_basedir.shellescape}\n#{sudovars}\n#{sudocmd} sh <<-'HOCHOEOS'\n#{script}HOCHOEOS\n")
          c.eof!
        end
      end
      availability = mitamae_available?
      outdated = mitamae_outdated?
      return unless !availability || outdated

      status = [availability ? nil : "unavailable", outdated ? "outdated" : nil].compact.join(" and ")
      raise "prepared MItamae, but it's still #{status}"
    end

    def run_mitamae(dry_run: false)
      with_host_node_json_file do
        itamae_cmd = [@mitamae_path, "local", "-j", host_node_json_path, *@mitamae_options]
        itamae_cmd.push("--dry-run") if dry_run
        itamae_cmd.push(*run_list)

        prepare_sudo do |_sh, sudovars, sudocmd|
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
    # Override deploy to only sync cookbooks directory
    def deploy(deploy_dir: nil, shm_prefix: [])
      @host_basedir = deploy_dir if deploy_dir

      ssh_cmd = ['ssh', *host.openssh_config.flat_map { |l| ['-o', "\"#{l}\""] }].join(' ')

      # Only include cookbooks directory, exclude everything else
      hostname = if host.hostname.include?(':')
                   "[#{host.hostname}]"
                 else
                   host.hostname
                 end
      rsync_cmd = [
        'rsync', '-a', '--copy-links', '--copy-unsafe-links', '--delete',
        '--rsh', ssh_cmd,
        'cookbooks', 'lib', 'plugins',
        "#{hostname}:#{host_basedir}"
      ]

      puts "=> $ #{rsync_cmd.shelljoin}"
      system(*rsync_cmd, chdir: base_dir) or raise 'failed to rsync'

      yield
    ensure
      if !deploy_dir || !keep_synced_files
        cmd = "rm -rf #{host_basedir.shellescape}"
        puts "=> #{host.name} $ #{cmd}"
        ssh_run(cmd, error: false)
      end
    end

    #   def prepare_sudo(password = host.sudo_password)
    #     unless host.sudo_required?
    #       yield nil, nil, ""
    #       return
    #     end

    #     raise "sudo password not present" if !host.nopasswd_sudo? && password.nil?

    #     sudo_cmd = host.properties[:sudo_command] || "sudo"

    #     if host.nopasswd_sudo?
    #       yield nil, nil, "#{sudo_cmd} "
    #       return
    #     end

    #     raise "doas doesn't support password passthrough" if sudo_cmd == "doas"

    #     passphrase_env_name = "HOCHO_PA_#{SecureRandom.hex(8).upcase}"
    #     temporary_passphrase = SecureRandom.base64(129).chomp
    #     derive = check_pbkdf2
    #     encrypted_password = encrypt_password(password, temporary_passphrase)

    #     begin
    #       temp_executable = create_askpass_executable(encrypted_password, derive)

    #       sh = [
    #         "#{passphrase_env_name}=#{temporary_passphrase.shellescape}",
    #         "SUDO_ASKPASS=#{temp_executable.shellescape}",
    #         sudo_cmd.to_s,
    #         "-A"
    #       ].join(' ')

    #       exp = [
    #         "export #{passphrase_env_name}=#{temporary_passphrase.shellescape}",
    #         "export SUDO_ASKPASS=#{temp_executable.shellescape}", ""
    #       ].join("\n")

    #       cmd = "#{sudo_cmd} -A "

    #       yield sh, exp, cmd
    #     ensure
    #       begin
    #         ssh_run("rm -f #{temp_executable.shellescape}")
    #       rescue StandardError
    #         nil
    #       end
    #     end
    #   end

    #   def check_pbkdf2
    #     local_supports_pbkdf2 = system(*%w[openssl enc -pbkdf2], in: File::NULL, out: File::NULL, err: %i[child out])
    #     remote_supports_pbkdf2 = begin
    #       exitstatus, * = ssh_run("openssl enc -pbkdf2", error: false, &:eof!)
    #       exitstatus.zero?
    #     end
    #     local_supports_pbkdf2 && remote_supports_pbkdf2 ? %w[-pbkdf2] : []
    #   end

    #   def encrypt_password(password, encrypt_password)
    #     IO.pipe do |r, w|
    #       w.write encrypt_password
    #       w.close
    #       IO.popen(["openssl", "enc", "-aes-128-cbc", "-pass", "fd:5", "-a", "-md", "sha256", *derive, { 5 => r }],
    #                "r+") do |io|
    #         io.puts password
    #         io.close_write
    #         io.read.chomp
    #       end
    #     end
    #   end

    #   def create_askpass_executable(encrypted_password, derive = [])
    #     tmpdir = host_shmdir ? "TMPDIR=#{host_shmdir.shellescape} " : nil
    #     temp_executable = ssh.exec!("#{tmpdir}mktemp").chomp
    #     raise unless temp_executable.start_with?("/")

    #     temp_executable_create_cmd = [
    #       "chmod 0700 #{temp_executable.shellescape}",
    #       "cat > #{temp_executable.shellescape}"
    #     ].join('; ')

    #     temp_openssl_cmd = [
    #       "exec",
    #       "openssl",
    #       "enc",
    #       "-aes-128-cbc",
    #       "-d",
    #       "-a",
    #       "-md",
    #       "sha256",
    #       derive.shelljoin,
    #       "-pass",
    #       "env:#{passphrase_env_name}",
    #       "<<<",
    #       encrypted_password.shellescape
    #     ].join(' ')

    #     temp_executable_data = "#!/bin/sh\n#{temp_openssl_cmd}\n"

    #     ssh_run(temp_executable_create_cmd) do |ch|
    #       ch.send_data(temp_executable_data)
    #       ch.eof!
    #     end

    #     temp_executable
    #   end
  end
end

Hocho::Drivers::Mitamae.prepend(HochoOpenBSDPatches::MitamaePatches)
Hocho::Drivers::SshBase.prepend(HochoOpenBSDPatches::SshBasePatches)
