# == Class: ldap::params
#
# Default paramaters for different operating systems, etc
#
class ldap::params {

  $client_package_ensure   = 'present'
  $client_config_template  = 'ldap/ldap.conf.erb'

  $client_ssl      = false
  $client_ssl_cert = undef

  $server_package_ensure  = 'present'
  $server_service_enable  = true
  $server_service_ensure  = 'running'
  $server_service_manage  = true
  $server_config_template = 'ldap/slapd.conf.erb'
  $server_directory       = '/var/lib/ldap'

  $server_log_level = 'none'

  $server_ssl       = false
  $server_ssl_ca    = undef
  $server_ssl_cert  = undef
  $server_ssl_key   = undef

  $server_bind_anon = true

  $server_modules   = [ 'back_bdb' ]
  $server_schemas   = [ 'core', 'cosine', 'nis', 'inetorgperson' ]
  $server_indexes   = [ 'objectclass  eq',
                        'entryCSN     eq',
                        'entryUUID    eq',
                        'uidNumber    eq',
                        'gidNumber    eq',
                        'cn           pres,sub,eq',
                        'sn           pres,sub,eq',
                        'uid          pres,sub,eq',
                        'displayName  pres,sub,eq' ]

  case $::osfamily {
    'Debian': {
      $client_package_name     = ['libldap-2.4-2']
      $client_config_file      = '/etc/ldap/ldap.conf'

      $server_package_name     = ['slapd']
      $server_service_name     = 'slapd'
      $server_config_file      = '/etc/ldap/slapd.conf'
      $server_default_file     = '/etc/default/slapd'
      $server_default_template = 'ldap/debian/defaults.erb'
    }
    default: {
      fail("${::module_name} is not supported on ${::operatingsystem}.")
    }
  }
}
