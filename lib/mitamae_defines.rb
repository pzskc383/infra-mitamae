define :block_in_file, content: nil, marker_start: nil, marker_end: nil do
  file params[:name] do
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
  operations = params[:lines].map do |line|
    operation = case line
                when Hash, ::Hashie::Mash
                  line
                when String
                  match = %r{(?<key>[^=]+)=(?<value>.+)}.match(line)
                  if match.nil?
                    { line: line }
                  else
                    {
                      line: "#{match[:key]}=#{match[:value]}",
                      regexp: %r{#{Regexp.escape(match[:key])}\s*=\s*}
                    }
                  end
                else
                  raise "Unknown line supplied: #{line.class}"
                end

    operation[:append] ||= true
    operation[:regexp] ||= %r{#{Regexp.escape(operation[:line])}}

    operation
  end

  file params[:name] do
    action :edit
    block do |data|
      operations.each do |cmd|
        replacements = 0
        data.gsub!(%r{^.*$}) do |l|
          if cmd[:regexp].match?(l) && cmd[:line] != l
            ::MItamae.logger.debug "Replacing #{l} with #{cmd[:line]}"
            replacements += 1
            cmd[:line]
          else
            l
          end
        end
        "#{data}\n#{cmd[:line]}" if replacements == 0 && cmd[:append]
      end
    end
  end
end

define :line_in_file, line: nil, pattern: nil, append: true do
  ::MItamae.logger.warning "using slow compat method!"
  lines_in_file params[:name] do
    lines [{
      line: params[:line],
      pattern: params[:pattern],
      append: params[:append]
    }]
  end
end

NOTIFY_RX = %r{(?<action>[^@]+)@(?<resource>[^\[]+)\[(?<name>[^\]]+)\]}

# format: notify! "run@execute[my operation]"
define :notify! do
  parsed = NOTIFY_RX.match(params[:name])
  raise "invalid notify! spec: #{params[:name]}" if parsed.nil?

  local_block_name = ["notify", parsed[:action], parsed[:resource], parsed[:name]].join('/')

  local_ruby_block local_block_name do
    block {} # rubocop:disable Lint/EmptyBlock
    notifies parsed[:action].to_sym, "#{parsed[:resource]}[#{parsed[:name]}]"
  end
end
