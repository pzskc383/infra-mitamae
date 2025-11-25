include_recipe 'dynamic.rb'

define :pf_conf, mode: "0600", content: nil do
  file params[:name] do
    mode params[:mode]
    content params[:content] if params[:content]
    notifies :run, "execute[reload_pf]"
  end
end

%w[hostname.pflog0 hostname.pflog1].each do |f|
  pf_conf "/etc/#{f}" do
    mode "0600"
    content "up"
  end
end

pf_conf "/etc/pf.conf" do
  mode "0600"
end

pf_conf "/etc/pf" do
  mode "0700"
end

pf_conf "/etc/pf/martians.table" do
  mode "0600"
end

pf_conf "/etc/pf/banned.table" do
  mode "0600"
  content ""
  not_if "stat /etc/pf/banned.table"
end

%w[block.anchor icmp.anchor scrub.anchor outgoing.anchor].each do |f|
  pf_conf "/etc/pf/#{f}" do
    mode "0600"
  end
end
