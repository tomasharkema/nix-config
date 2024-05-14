{ config, pkgs, ... }:
pkgs.writeText "ldap.conf" ''
  <ldap>
      <config>
          <credential>
            class = Password
            password_field = password
            password_type = self_check
          </credential>
          <store>
            <ldap_server_options>
                debug = 3
                timeout = 30
            </ldap_server_options>
            class = LDAP
            ldap_server = ipa.harkema.intra
            Include ${config.age.secrets.ldap.path}
            start_tls = 0
            <start_tls_options>
                verify = none
            </start_tls_options>
            user_basedn = "cn=users,cn=accounts,dc=harkema,dc=intra"
            user_filter = "(&(objectClass=inetorgperson)(uid=%s))"
            user_scope = one
            user_field = uid
            <user_search_options>
                deref = always
            </user_search_options>
            # Important for role mappings to work:
            use_roles = 1
            role_basedn = "cn=groups,cn=accounts,dc=harkema,dc=intra"
            role_filter = "(&(objectClass=groupofnames)(member=%s))"
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
