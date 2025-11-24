# Monkey-patch MItamae::Backend to support doas/pkexec/sudo
class MItamae::Backend
  private

  def build_command(command, user: nil, cwd: nil)
    if command.is_a?(Array)
      command = Shellwords.shelljoin(command)
    end

    if cwd
      command = "cd #{cwd.shellescape} && #{command}"
    end

    if user
      command = "cd ~#{user.shellescape} ; #{command}"

      # Detect available su command
      command = if File.exist?("/usr/bin/doas")
        "doas -u #{user.shellescape} #{@shell.shellescape} -c #{command.shellescape}"
      elsif File.exist?("/usr/bin/pkexec")
        "pkexec --user #{user.shellescape} #{@shell.shellescape} -c #{command.shellescape}"
      else
        "sudo -H -u #{user.shellescape} -- #{@shell.shellescape} -c #{command.shellescape}"
      end
    end

    command
  end
end
