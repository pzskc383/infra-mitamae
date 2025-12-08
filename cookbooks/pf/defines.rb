node.reverse_merge!({
  pf_snippets: [],
})
# check and reload pf config
execute "reload_pf" do
  action :nothing
  command "pfctl -f /etc/pf.conf"
  not_if "pfctl -nf /etc/pf.conf"
end

# Dynamic services anchor from node attributes
template "pf_dynamic_services" do
  action :nothing
  path "/etc/pf/services.anchor"
  mode "0640"

  notifies :run, "execute[reload_pf]"
end

define :pf_snippet, content: nil do
  node[:pf_snippets] << (params[:content] || params[:name])

  notify!("template[pf_dynamic_services]") { action :create }
end

define :pf_conf, content: nil do
    def_mode = "0600"
    if params[:content]
      file params[:name] do
        mode def_mode
        content params[:content]
        notifies :run, "execute[reload_pf]"
      end
    else
      remote_file params[:name] do
        mode def_mode
        source "files/#{::File.basename(params[:name])}"
        notifies :run, "execute[reload_pf]"
      end
    end
end