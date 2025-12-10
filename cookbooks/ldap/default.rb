node.reverse_merge!({
  ldapd_base_dn: '',
  ldapd_bind_pw: '',
  ldapd_service_accounts: %w[dovecot smtpd]
})

openbsd_package "openldap-client"

base_dn = node[:ldapd_base_dn]
bind_dn = "cn=root,#{base_dn}"

http_request "/etc/ldap/misc.schema" do
  url "https://git.openldap.org/openldap/openldap/-/raw/OPENLDAP_REL_ENG_2_6_10/servers/slapd/schema/misc.schema"
end

if node[:ldapd_bind_pw_hash].empty?
  encrypt_result = run_command("echo #{node[:ldapd_bind_pw]} |encrypt")
  raise RuntimeError if encrypt_result.exit_status != 0
  node[:ldapd_bind_pw_hash] = "{CRYPT}#{encrypt_result.stdout}"
end

template "/etc/ldapd.conf" do
  mode "0600"
  owner "root"
  group "wheel"
  variables(
    base_dn: node[:ldapd_base_dn],
    bind_dn: bind_dn,
    bind_pw: node[:ldapd_bind_pw_hash],
    service_accounts: node[:ldapd_service_accounts]
  )
end

service "ldapd" do
  action %i[enable start]
end

define :ldap_object, attributes: [] do
  dn = params[:name]
  attrs = params[:attributes]

  identifier, search_base = dn.split(',')
  search_base = base_dn if search_base.length < base_dn.length
  object_check_result = run_command("ldap search -b '#{search_base}' -D '#{bind_dn}' -w '#{node[:ldapd_bind_pw]}' '(#{identifier})'|wc -l")
  has_object = object_check_result.stdout.chomp!.to_i > 0
  
  ::MItamae.logger.info "ldap check for #{dn}:"
  ::MItamae.logger.info object_check_result.inspect

  
  file "/tmp/ldapadd.ldif" do
    ldif_lines = ["dn: #{dn}"]
    attrs.each do |a|
      k = a.keys.first
      ldif_lines << "#{k}: #{a[k]}"
    end
    content ldif_lines.join("\n")

    not_if { has_object }
  end

  execute "add #{dn} to ldap server" do
    command "ldapadd -H ldapi://%2fvar%2frun%2fldapi -D '#{bind_dn}' -w '#{node[:ldapd_bind_pw]}' -f /tmp/ldapadd.ldif"

    not_if { has_object }
  end
  
  file "/tmp/ldapadd.ldif" do
    not_if { has_object }
    action :delete
  end
  
  file "/tmp/ldapmodify.ldif" do
    ldif_lines = ["dn: #{dn}", "changeType: modify"]
    attrs_keyed = {}

    attrs.each do |a|
      k = a.keys.first
      attrs_keyed[k] ||= []
      attrs_keyed[k] << a[k]
    end

    attrs_keyed.each do |attr, values|
      ldif_lines << "replace: #{attr}"
      values.each do |v|
        ldif_lines << "#{attr}: #{v}"
      end
      ldif_lines << "-"
    end

    content ldif_lines.join("\n")

    only_if { has_object }
  end

  execute "modify #{dn} on ldap server" do
    command "ldapmodify -H ldapi://%2fvar%2frun%2fldapi -D '#{bind_dn}' -w '#{node[:ldapd_bind_pw]}' -f /tmp/ldapmodify.ldif"

    only_if { has_object }
  end
  
  file "/tmp/ldapmodify.ldif" do
    only_if { has_object }
    action :delete
  end
end

# holds 'example' when base_dn: dc=example,dc=com
root_dc_part = base_dn.split(',').first.split('=').last

ldap_objects = {
  base_dn => [
    { objectClass: "dcObject" },
    { objectClass: "organization" },
    { dc: root_dc_part },
    { o: "LDAP Server" },
    { description: "Root entry for LDAP server" },
  ],
  "ou=people,#{base_dn}" => [
    { objectClass: "organizationalUnit" },
    { ou: "people" },
    { description: "All users in organization" },
  ],
  "ou=services,#{base_dn}" => [
    { objectClass: "organizationalUnit" },
    { ou: "services" },
    { description: "All services in organization" },
  ]
}

node[:ldapd_service_accounts].each do |service|
  ldap_objects["cn=#{service},#{base_dn}"] = [
    { objectClass: "person" },
    { cn: service },
    { sn: service },
    { description: "a #{service} service account" },
  ]
end

ldap_objects.each do |dn, attributes|
  ldap_object dn do
    attributes attributes
  end
end