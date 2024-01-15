{
  config,
  pkgs,
  ...
}:
pkgs.writeText "ldap.conf" ''
  <ldap>
      <config>
          <credential>
          class = Password
          password_field = password
          password_type = self_check
          </credential>
          <store>
          class = LDAP
          ldap_server = ipa.harkema.io
          <ldap_server_options>
              timeout = 30
          </ldap_server_options>
          #binddn = "cn=admin,dc=harkema,dc=io"
          #Include ${config.age.secrets.ldap.path}
          start_tls = 0
          <start_tls_options>
              verify = none
          </start_tls_options>
          user_basedn = "ou=users,dc=harkema,dc=io"
          user_filter = "(&(objectClass=inetOrgPerson)(cn=%s))"
          user_scope = one
          user_field = cn
          <user_search_options>
              deref = always
          </user_search_options>
          # Important for role mappings to work:
          use_roles = 1
          role_basedn = "ou=groups,dc=harkema,dc=io"
          role_filter = "(&(objectClass=groupOfNames)(member=%s))"
          role_scope = one
          role_field = cn
          role_value = dn
          <role_search_options>
              deref = always
          </role_search_options>
          </store>
      </config>
      <role_mapping>
          # Make all users in the hydra_admin group Hydra admins
          hydra_admin = admin
          # Allow all users in the dev group to restart jobs and cancel builds
          dev = restart-jobs
          dev = cancel-build
      </role_mapping>
  </ldap>
''
