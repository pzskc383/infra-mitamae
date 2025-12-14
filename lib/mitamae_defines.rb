define :block_in_file, content: nil, marker_start: nil, marker_end: nil do
  filename = params[:name]
  run_command("test -f #{filename} || touch #{filename}", error: false)

  file filename do
    action :edit
    block do |data|
      marker_start = params[:marker_start] || "# BEGIN MITAMAE MANAGED BLOCK"
      marker_end = params[:marker_end] || "# END MITAMAE MANAGED BLOCK"

      data.gsub!(%r{\n#{Regexp.escape(marker_start)}.*?#{Regexp.escape(marker_end)}\n?}m, "")

      data << "\n#{marker_start}\n#{params[:content]}#{marker_end}\n"
    end
  end
end

define :lines_in_file, lines: [] do
  commands = params[:lines].map do |line|
    command =
      case line
      when ::Hashie::Mash
        line
      else
        hash_line =
          case line
          when Hash
            ::Hashie::Mash.new(line)
          when String
            match = %r{(?<key>[^=]+?)(?<equals>\s*=\s*)(?<value>.+)}.match(line)
            if match.nil?
              { line: line }
            else
              {
                line: "#{match[:key]}#{match[:equals]}#{match[:value]}",
                regexp: %r{^\s*#?\s*#{Regexp.escape(match[:key])}\s*=.*$}
              }
            end
          else
            raise "Unknown line supplied: #{line.class}"
          end
        Hashie::Mash.new(hash_line)
      end
    command.append = true unless command.append == false
    if command.regexp.nil?
      command.regexp = %r{#{Regexp.escape(command.line)}}
    elsif command.regexp.is_a? String
      command.regexp = %r{#{Regexp.escape(command.regexp)}}
    end
    command
  end

  file params[:name] do
    action :edit
    block do |data|
      commands.each do |cmd|
        cmd.replacements = 0
        cmd.matches = 0
        data.gsub!(cmd.regexp) do |lm|
          already_replaced = lm == cmd.line
          cmd.replacements += 1 unless already_replaced
          cmd.matches += 1
          cmd.line.chomp
        end
        data.replace "#{data}#{cmd.line}\n" if cmd.matches == 0 && cmd.append
      end
    end
  end
end

NOTIFY_RX = %r{(?<action>[^@]+)@(?<resource>[^\[]+)\[(?<name>[^\]]+)\]}

# format: notify! "run@execute[my command]"
define :notify! do
  parsed = NOTIFY_RX.match(params[:name])
  raise "invalid notify! spec: #{params[:name]}" if parsed.nil?

  local_block_name = ["notify", parsed[:action], parsed[:resource], parsed[:name]].join(':')

  local_ruby_block local_block_name do
    block {} # rubocop:disable Lint/EmptyBlock
    notifies parsed[:action].to_sym, "#{parsed[:resource]}[#{parsed[:name]}]"
  end
end
