# == Class: ldap::params
#
# Default paramaters for different operating systems, etc
#
class ldap::params {

  $client_package_ensure   = 'present'
  $client_config_template  = 'ldap/ldap.conf.erb'

  $client_ssl             = false
  $client_ssl_cacert      = undef
  $client_ssl_cacertdir   = undef
  $client_ssl_cert        = undef
  $client_ssl_key         = undef
  $client_ssl_reqcert     = 'demand'

  $server_package_ensure      = 'present'
  $server_service_enable      = true
  $server_service_ensure      = 'running'
  $server_service_manage      = true
  $server_config_template     = 'ldap/slapd.conf.erb'
  $server_directory           = '/var/lib/ldap'
  $server_db_config_file      = "${server_directory}/DB_CONFIG"
  $server_db_config_template  = 'ldap/DB_CONFIG.erb'

  $server_log_level = 'none'

  $server_ssl       = false
  $server_ssl_ca    = undef
  $server_ssl_cert  = undef
  $server_ssl_key   = undef

  $config           = false
  $monitor          = false

  $server_bind_anon = false
  $server_bind_v2   = true

  $server_overlays  = [ ]
  $server_modules   = [ ]
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

  $gem_ensure       = 'present'

  case $::osfamily {
    'Debian': {
      $ldap_config_directory   = '/etc/ldap'
      $os_config_directory     = '/etc/default'

      $client_package_name     = 'libldap-2.4-2'
      $client_config_file      = "${ldap_config_directory}/ldap.conf"

      $server_package_name     = 'slapd'
      $server_service_name     = 'slapd'
      $server_config_file      = "${ldap_config_directory}/slapd.conf"
      $server_default_file     = "${os_config_directory}/slapd"
      $server_default_template = 'ldap/debian/defaults.erb'
      $gem_name                = 'net-ldap'
    }
    'RedHat': {
      $ldap_config_directory   = '/etc/openldap'
      $os_config_directory     = '/etc/sysconfig'

      $client_package_name     = 'openldap-clients'
      $client_config_file      = "${ldap_config_directory}/ldap.conf"

      $server_package_name     = 'openldap-servers'
      $server_service_name     = 'slapd'
      $server_config_file      = "${ldap_config_directory}/slapd.conf"
      $server_default_file     = "${os_config_directory}/ldap"
      $server_default_template = 'ldap/redhat/sysconfig.erb'
      $gem_name                = 'net-ldap'
    }
    default: {
      fail("${::module_name} is not supported on ${::osfamily}.")
    }
  }
}
