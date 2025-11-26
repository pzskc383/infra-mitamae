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

define :line_in_file, line: nil, pattern: nil, append: true do
  pattern = params[:pattern]
  pattern ||= %r{#{Regexp.escape(params[:line])}}

  file params[:name] do
    action :edit
    block do |data|
      replacements = 0
      data.gsub!(%r{^.*$}) do |l|
        if pattern.match?(l)
          ::MItamae.logger.debug "Replacing #{l} with #{params[:line]}"
          replacements += 1
          params[:line]
        else
          l
        end
      end
      "#{data}\n#{params[:line]}" if replacements == 0 && params[:append]
    end
  end
end

define :line_set, set: nil do
  key, value = params[:set].split('=', 1)

  config_set params[:name] do
    key key
    value value
  end
end

define :config_set, key: nil, value: nil do
  raise "key not set" if params[:key].nil?

  key = params[:key]
  value = params[:value] || ""

  line_in_file params[:name] do
    line "#{key}=#{value}"
    pattern %r{#{Regexp.escape(key)}\s*=\s*}
  end
end

define :notify!, action: nil do
  local_block_name = "notify_#{params[:action]}_#{params[:name]}".gsub(%r{[^a-z0-9_]}, '')
  local_ruby_block local_block_name do
    block {} # rubocop:disable Lint/EmptyBlock
    notifies params[:action], params[:name]
  end
end
