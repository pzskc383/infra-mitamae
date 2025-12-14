node.reverse_merge!({
  ldapd_base_dn: '',
  ldapd_bind_pw: '',
  ldapd_service_accounts: %w[dovecot smtpd],
  ldapd_extra_schemas: %w[misc]
})

openbsd_package "openldap-client"

base_dn = node[:ldapd_base_dn]
bind_dn = "cn=root,#{base_dn}"

if node[:ldapd_bind_pw_hash].empty?
  encrypt_result = run_command("echo #{node[:ldapd_bind_pw]} |encrypt")
  raise RuntimeError if encrypt_result.exit_status != 0

  node[:ldapd_bind_pw_hash] = "{CRYPT}#{encrypt_result.stdout}"
end

remote_file "/etc/ldap/misc.schema" do
  source "files/schema/misc.schema"
end

template "/etc/ldapd.conf" do
  source "templates/ldapd.conf.erb"
  mode "0600"
  owner "root"
  group "wheel"

  variables(
    base_dn: node[:ldapd_base_dn],
    bind_dn: bind_dn,
    bind_pw: node[:ldapd_bind_pw_hash],
    service_accounts: node[:ldapd_service_accounts],
    schemas: node[:ldapd_extra_schemas]
  )

  notifies :restart, "service[ldapd]"
end

service "ldapd" do
  action %i[enable start]
end

# holds 'example' when base_dn: dc=example,dc=com
root_dc_part = base_dn.split(',').first.split('=').last

ldap_objects = {
  base_dn => {
    objectClass: %w[dcObject organization],
    dc: root_dc_part,
    o: "LDAP Server",
    description: "Root entry for LDAP server"
  },
  "ou=people,#{base_dn}" => {
    objectClass: "organizationalUnit",
    ou: "people",
    description: "All users in organization"
  },
  "ou=services,#{base_dn}" => {
    objectClass: "organizationalUnit",
    ou: "services",
    description: "All services in organization"
  }
}

node[:ldapd_service_accounts].each do |service|
  ldap_objects["cn=#{service},#{base_dn}"] = {
    objectClass: "person",
    cn: service,
    sn: service,
    description: "a #{service} service account"
  }
end

node[:ldapd_server] = {
  host: "ldapi://%2fvar%2frun%2fldapi",
  root_dn: node[:ldapd_base_dn],
  bind_dn: bind_dn,
  bind_secret: node[:ldapd_bind_pw]
}

ldap_objects.each do |dn, attributes|
  ldap_object dn do
    server node[:ldapd_server]
    attrs attributes
  end
end
