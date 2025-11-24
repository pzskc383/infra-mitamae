module MItamae
  class Node
    alias orig_initialize initialize

    def initialize(hash, backend)
      orig_initialize(hash, backend)
      backend.node = self
    end
  end
end

module MItamae
  class Backend
    attr_accessor :node

    private

    def build_command(command, user: nil, cwd: nil)
      command = Shellwords.shelljoin(command) if command.is_a?(Array)
      command = "cd #{cwd.shellescape} && #{command}" if cwd

      if user
        sudo_cmd = @node&.[](:sudo_command) || "sudo"
        command = "cd ~#{user.shellescape} ; #{command}"
        command = "#{sudo_cmd} -u #{user.shellescape} #{@shell.shellescape} -c #{command.shellescape}"
      end

      command
    end
  end
end
