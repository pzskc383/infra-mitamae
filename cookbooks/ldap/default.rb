node.reverse_merge!({
  ldapd_base_dn: '',
  ldapd_bind_pw: '',
  ldapd_service_accounts: [
    { name: "dovecot" },
    { name: "smtpd" }
  ],
  ldapd_extra_schemas: %w[custom]
})

openbsd_package "openldap-client"

base_dn = node[:ldapd_base_dn]
bind_dn = "cn=root,#{base_dn}"

node[:ldapd_service_accounts].map do |svc|
  if svc[:password].nil?
    generate_result = run_command("dd if=/dev/random bs=1 |tr -dc 'a-zA-Z0-9'|dd bs=1 count=20")
    svc[:password] = generate_result.stdout.chomp
  end

  if svc[:hashed_password].nil?
    encrypt_result = run_command("echo #{svc[:password]} |encrypt")
    svc[:hashed_password] = encrypt_result.stdout.chomp
  end

  svc
end

if node[:ldapd_bind_pw_hash].nil?
  encrypt_result = run_command("echo #{node[:ldapd_bind_pw]} |encrypt")

  node[:ldapd_bind_pw_hash] = "{CRYPT}#{encrypt_result.stdout.chomp}"
end

remote_file "/etc/ldap/custom.schema" do
  source "files/custom.schema"
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

  notifies :restart, "service[ldapd]", :immediately
end

service "ldapd" do
  action %i[enable start]
end

# holds 'example' when base_dn: dc=example,dc=com
root_dc_part = base_dn.split(',').first.split('=').last

ldap_objects = [
  {
    dn: base_dn,
    objectClass: %w[dcObject organization],
    dc: root_dc_part,
    o: "LDAP Server",
    description: "Root entry for LDAP server"
  },
  {
    dn: "ou=accounts,#{base_dn}",
    objectClass: "organizationalUnit",
    ou: "accounts",
    description: "All accounts"
  },
  {
    dn: "ou=services,#{base_dn}",
    objectClass: "organizationalUnit",
    ou: "services",
    description: "All services"
  }
]

node[:ldapd_service_accounts].each do |service|
  ldap_objects << {
    dn: "name=#{service.name},ou=services,#{base_dn}",
    objectClass: "authService",
    name: service.name,
    userPassword: "{CRYPT}#{service.hashed_password}"
  }
end

node[:ldapd_server] = {
  host: "ldapi://%2fvar%2frun%2fldapi",
  root_dn: node[:ldapd_base_dn],
  bind_dn: bind_dn,
  bind_secret: node[:ldapd_bind_pw]
}

ldap_objects.each do |obj|
  dn = obj[:dn]
  attrs = obj.except(:dn)
  ldap_object dn do
    dn dn
    server node[:ldapd_server]
    attrs attrs
  end
end
