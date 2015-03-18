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
  $client_ssl_ciphersuite = undef

  $client_sizelimit = undef
  $client_timelimit = 15

  $server_package_ensure      = 'present'
  $server_service_enable      = true
  $server_service_ensure      = 'running'
  $server_service_manage      = true
  $server_config_template     = 'ldap/slapd.conf.erb'
  $server_backend             = 'bdb'

  $server_log_level = 'none'

  $server_ssl        = false
  $server_ssl_cacert = undef
  $server_ssl_cert   = undef
  $server_ssl_key    = undef
  $server_ssl_verify_client = undef
  $server_ssl_ciphersuite = undef

  $config           = false
  $monitor          = false

  $server_access = [
    # to what
    { 'attrs=userPassword,shadowLastChange' => [
      # by who => access
      { 'self' => '@@writeable_on_sync_provider_only@@' },
      { 'anonymous' => 'auth' },
    ] },
    { 'attrs=objectClass,cn,uid,uidNumber,gidNumber,gecos,homeDirectory,loginShell,member,memberUid,entry' => [
      { '*' => 'read' },
    ] },
  ]
  $server_disable_safe_default_acls = false

  $server_bind_anon = false
  $server_bind_v2   = true
  $server_authz_regexp = []

  $server_overlays  = [ ]
  $server_modules   = [ ]
  $server_schemas   = [ 'core', 'cosine', 'nis', 'inetorgperson' ]
  $server_extra_schemas = [ ]
  $server_schema_source_directory = 'puppet:///files/ldap/schema'
  $server_indexes   = [ 'objectclass  eq',
                        'entryCSN     eq',
                        'entryUUID    eq',
                        'uidNumber    eq',
                        'gidNumber    eq',
                        'cn           pres,sub,eq',
                        'sn           pres,sub,eq',
                        'uid          pres,sub,eq',
                        'displayName  pres,sub,eq' ]

  $server_sync_rid            = undef
  $server_sync_provider       = undef
  $server_sync_type           = undef
  $server_sync_interval       = undef
  $server_sync_retry          = undef
  $server_sync_filter         = undef
  $server_sync_scope          = undef
  $server_sync_attrs          = undef
  $server_sync_schemachecking = undef
  $server_sync_bindmethod     = undef
  $server_sync_binddn         = undef
  $server_sync_credentials    = undef
  $server_sync_saslmech       = undef
  $server_sync_tls_cert       = undef
  $server_sync_tls_key        = undef
  $server_sync_tls_cacert     = undef
  $server_sync_tls_reqcert    = undef

  $server_memberof_group_oc   = undef
  $server_refint_attributes   = undef

  $manage_package_dependencies = true
  $net_ldap_package_ensure     = 'present'

  case $::osfamily {
    'Debian': {
      $ldap_config_directory   = '/etc/ldap'
      $os_config_directory     = '/etc/default'
      $server_run_directory    = '/var/run/slapd'

      $client_package_name     = 'libldap-2.4-2'

      $ldapowner               = 'openldap'
      $ldapgroup               = 'openldap'

      $server_package_name     = 'slapd'
      $server_service_name     = 'slapd'
      $server_default_file     = "${os_config_directory}/slapd"
      $server_default_template = 'ldap/debian/defaults.erb'
      $server_directory        = '/var/lib/ldap'
      $net_ldap_package_name     = 'ruby-net-ldap'
      $net_ldap_package_provider = 'apt'
    }
    'OpenBSD': {
      $ldap_config_directory   = '/etc/openldap'
      $os_config_directory     = undef
      $server_run_directory    = '/var/run/openldap'

      $client_package_name     = 'openldap-client'

      $ldapowner               = '_openldap'
      $ldapgroup               = '_openldap'

      $server_package_name     = 'openldap-server'
      $server_service_name     = 'slapd'
      $server_default_file     = undef
      $server_default_template = undef
      $server_directory        = '/var/openldap-data'
      $net_ldap_package_name     = 'net-ldap'
      $net_ldap_package_provider = 'gem'
    }
    'RedHat': {
      $ldap_config_directory   = '/etc/openldap'
      $os_config_directory     = '/etc/sysconfig'
      $server_run_directory    = '/var/run/openldap'

      $client_package_name     = 'openldap-clients'

      $ldapowner               = 'ldap'
      $ldapgroup               = 'ldap'

      $server_package_name     = 'openldap-servers'
      $server_service_name     = 'slapd'
      $server_default_file     = "${os_config_directory}/ldap"
      $server_default_template = 'ldap/redhat/sysconfig.erb'
      $server_directory        = '/var/lib/ldap'
      $net_ldap_package_name     = 'net-ldap'
      $net_ldap_package_provider = 'gem'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $client_config_file         = "${ldap_config_directory}/ldap.conf"
  $server_config_file         = "${ldap_config_directory}/slapd.conf"
  $server_dynconfig_directory = "${ldap_config_directory}/slapd.d"
  $server_schema_directory    = "${ldap_config_directory}/schema"
  $pidfile                    = "${server_run_directory}/slapd.pid"
  $argsfile                   = "${server_run_directory}/slapd.args"

  $server_purge_dynconfig_directory = false

  $server_kerberos            = false
  $server_krb5_keytab         = "${ldap_config_directory}/ldap.keytab"
  $server_krb5_ticket_cache   = "${ldap_config_directory}/ldap.krb5cc"

  $server_db_config_file      = "${server_directory}/DB_CONFIG"
  $server_db_config_template  = 'ldap/DB_CONFIG.erb'
}
