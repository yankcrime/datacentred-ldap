# == Class: ldap::params
#
# Default paramaters for different operating systems, etc
#
class ldap::params {

  $server_package_ensure  = 'present'
  $server_service_enable  = true
  $server_service_ensure  = 'running'
  $server_service_manage  = true
  $server_config_template = 'ldap/slapd.conf.erb'

  case $::osfamily {
    'Debian': {
      $server_package_name = ['slapd']
      $server_service_name = 'slapd'
      $server_config_file  = '/etc/ldap/slapd.conf'
    }
    default: {
      fail("${::module_name} is not supported on ${::operatingsystem}.")
    }
  }

  $server_log_level = 'none'

  $server_modules   = [ 'back_bdb' ]
  $server_schemas   = [ 'core', 'cosine', 'nis', 'inetorgperson' ]
  $server_indexes   = [ 'index objectclass  eq',
                        'index entryCSN     eq',
                        'index entryUUID    eq',
                        'index uidNumber    eq',
                        'index gidNumber    eq',
                        'index cn           pres,sub,eq',
                        'index sn           pres,sub,eq',
                        'index uid          pres,sub,eq',
                        'index displayName  pres,sub,eq' ]

  $server_ssl       = false
  $server_ssl_ca    = undef
  $server_ssl_cert  = undef
  $server_ssl_key   = undef

  $server_directory = '/var/lib/ldap'
}
