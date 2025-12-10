node.reverse_merge!({
  pf_snippets: [],
})

# check and reload pf config
execute "reload_pf" do
  action :nothing
  command "pfctl -f /etc/pf.conf"
  not_if "pfctl -nf /etc/pf.conf"
end

template "pf_dynamic_services" do
  action :nothing
  path "/etc/pf.conf"
  mode "0600"
  notifies :run, "execute[reload_pf]"
end


define :pf_snippet, content: nil do
  node[:pf_snippets] << (params[:content] || params[:name])

  notify!("template[pf_dynamic_services]") { action :create }
end