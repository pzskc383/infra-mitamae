define :block_in_file, content: nil do
  file params[:name] do
    action :edit
    block do |data|
      marker_start = "# BEGIN MITAMAE MANAGED BLOCK"
      marker_end = "# END MITAMAE MANAGED BLOCK"

      data.gsub!(/\n#{Regexp.escape(marker_start)}.*?#{Regexp.escape(marker_end)}\n?/m, "")

      data << "\n#{marker_start}\n#{params[:content]}#{marker_end}\n"
    end
  end
end

define :line_in_file, line: nil, match_rx: nil do
  match_rx = params[:match_rx]
  match_rx ||= /#{Regexp.escape(params[:line])}/

  file params[:name] do
    action :edit
    block do |data|
      data.gsub!(/^.*$/) do |l|
        if match_rx.match?(l)
          ::MItamae.logger.debug "Replacing #{l} with #{params[:line]}"
          params[:line]
        else
          l
        end
      end
    end
  end
end

define :sshd_param, value: nil do
  k = params[:name]
  v = params[:value]
  line_in_file "/etc/ssh/sshd_config" do
    line "#{k} #{v}"
    match_rx %r{^#?\s*#{k}\s}
  end
end

define :pf_snippet, content: nil do
  node[:pf_snippets] ||= []
  node[:pf_snippets] << params[:content]

  unless node[:_pf_snippet_notifier]
    node[:_pf_snippet_notifier] = true

    local_ruby_block "pf snippets collector" do
      block {}
      notifies :create, "template[/etc/pf/services.anchor]"
    end
  end
end
