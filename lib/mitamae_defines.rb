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

define :line_in_file, line: nil, pattern: nil do
  pattern = params[:pattern]
  pattern ||= %r{#{Regexp.escape(params[:line])}}

  file params[:name] do
    action :edit
    block do |data|
      data.gsub!(%r{^.*$}) do |l|
        if pattern.match?(l)
          ::MItamae.logger.debug "Replacing #{l} with #{params[:line]}"
          params[:line]
        else
          l
        end
      end
    end
  end
end

define :notify!, action: nil do
  local_block_name = "notify_#{params[:action]}_#{params[:name]}".gsub(%r{[^a-z0-9_]}, '')
  local_ruby_block local_block_name do
    block {} # rubocop:disable Lint/EmptyBlock
    notifies params[:action], params[:name]
  end
end
