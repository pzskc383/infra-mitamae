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

      # Skip user switching - we're already root, don't call sudo/doas
      # if user
      #   command = "cd ~#{user.shellescape} ; #{command}"
      # end

      command
    end
  end
end
