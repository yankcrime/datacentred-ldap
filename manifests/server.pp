# == Class: ldap::server
#
#  This class manages the installation and configuration of an OpenLDAP Server
#
# === Parameters
#
# [*suffix*]
#   The domain for which the LDAP server provides information for.
#
# [*rootdn*]
#   The administrative user which has root access to the database schema.
#
# [*rootpw*]
#   The password for the rootdn administrative user.
#
# [*directory*]
#   Path to where the slapd database files should be stored.
#
# [*ldapowner*]
#   The owner of the slapd and database configuration files.
#
# [*ldapgroup*]
#   The group of the slapd and database configuration files.
#
# [*backend*]
#   Database backend to use.
#
# [*log_level*]
#   Daemon logging level, see http://www.openldap.org/doc/admin24/slapdconfig.html.
#
# [*schemas*]
#   An array of schema files which should be loaded in.
#
# [*extra_schemas*]
#   An array of schema files which should be importe from the master and loaded in.
#
# [*schema_directory*]
#   Directory to import the extra schema files into.
#
# [*schema_source_directory*]
#   Directory to import the extra schema files from, usually a puppet:///files source.
#
# [*modules*]
#   An array of modules which should be loaded in.
#
# [*indexes*]
#   An array of indexes which should be created in the database.
#
# [*overlays*]
#   An array of overlays which should be added to the database.
#
# [*ssl*]
#   Whether the server should listen on port 636 (SSL).
#   Default: false
#
# [*ssl_cacert*]
#   Path to the certificate authority file for the LDAP SSL certificate.
#
# [*ssl_cert*]
#   Path to the SSL certificate file.
#
# [*ssl_key*]
#   Path to the SSL certificate key.
#
# [*ssl_verify_client*]
#   Whether and how to verify the client.
#
# [*kerberos*]
#   Whether to use kerberos.
#
# [*krb5_keytab*]
#   Keytab file to configure for the server to use for accepting kerberized
#   client connections.
#
# [*krb5_ticket_cache*]
#   Ticket cache file to configure for the server to use for establishing
#   kerberized LDAP connections to other servers, e.g. via the ldap backend or
#   syncrepl overlay.
#
# [*access*]
#   ACLs to configure for the server. An array of hashes of arrays of hashes
#   describing the ACLs:
#
#   $access = [
#     { 'to what' => [
#       { <implicit> "uidNumber=0... LDAPI" => "$access_for_ldapi_rootdn" },
#       { 'by who' => 'access' },
#       { 'by who' => 'access' },
#       { <implicit> "*" => "none" } ] },
#     { 'to what' => [ ... ] },
#     <implicit> { '*' => [
#       { <implicit> "uidNumber=0... LDAPI" => "$access_for_ldapi_rootdn" },
#       { <implicit> "*" => "none" } ] },
#   ]
#
#   'access' can be a special placeholder @@writeable_on_sync_provider_only@@
#   which will by default be 'write' on the syncrepl provider and 'read' on any
#   consumer.
#
#   default:
#   $access = [
#     { 'attrs=userPassword,shadowLastChange' => [
#       { 'self' => '@@writeable_on_sync_provider_only@@' },
#       { 'anonymous' => 'auth' },
#     ] },
#     { 'attrs=objectClass,cn,uid,uidNumber,gidNumber,gecos,homeDirectory,loginShell,member,memberUid,entry' => [
#       { '*' => 'read' },
#     ] },
#   ]
#
# [*access_writeable_on_sync_provider_only*]
#   Can provide an alternative value for access the
#   @@writeable_on_sync_provider_only@@ placeholder in ACLs. Since this can be
#   overridden using e.g. the hiera lookup hierarchy the logic for setting this
#   to what can be as complex as necessary. Default: write on provider, read on
#   any consumer.
#
# [*access_for_ldapi_rootdn*]
#   What access to grant to the LDAPI access DN. Default: write.
#
# [*dynconfig_directory*]
#   Path to the slapd.d cn=config backend directory.
#
# [*purge_dynconfig_directory*]
#   Whether to delete the cn=config backend directory to make sure that
#   slapd.conf is used. Default: false.
#
# [*config*]
#   Whether the config database should be built (cn=config).
#
# [*configdn*]
#   The root dn for the config database (Default: rootdn).
#
# [*configpw*]
#   The password for the configdn user (Default: rootpw).
#
# [*monitor*]
#   Whether the monitor database should be built (cn=Monitor).
#
# [*monitordn*]
#   The root dn for the monitor database (Default: rootdn).
#
# [*monitorpw*]
#   The password for the monitordn user (Default: rootpw).
#
# [*bind_anon*]
#   Allow anonymous (unauthenticated) binding to the LDAP server.
#   Default: false
#
# [*bind_v2*]
#   Whether to support LDAPv2.
#   Default: true
#
# === Examples
#
#  class { 'ldap::server':
#    suffix => 'dc=example,dc=com',
#    rootdn => 'cn=admin,dc=example,dc=com',
#    rootpw => 'llama',
#  }
#
class ldap::server (
  $suffix,
  $rootdn,
  $rootpw,
  $configdn         = $rootdn,
  $configpw         = $rootpw,
  $monitordn        = $rootdn,
  $monitorpw        = $rootpw,
  $directory        = $ldap::params::server_directory,
  $backend          = $ldap::params::server_backend,
  $log_level        = $ldap::params::server_log_level,
  $schemas          = $ldap::params::server_schemas,
  $extra_schemas    = $ldap::params::server_extra_schemas,
  $schema_directory = $ldap::params::server_schema_directory,
  $schema_source_directory = $ldap::params::server_schema_source_directory,
  $modules          = $ldap::params::server_modules,
  $indexes          = $ldap::params::server_indexes,
  $overlays         = $ldap::params::server_overlays,
  $sync_provider    = undef,
  $access           = $ldap::params::server_access,
  $access_writeable_on_sync_provider_only = undef,
  $access_for_ldapi_rootdn = undef,
  $ssl              = $ldap::params::server_ssl,
  $ssl_cacert       = $ldap::params::server_ssl_cacert,
  $ssl_cert         = $ldap::params::server_ssl_cert,
  $ssl_key          = $ldap::params::server_ssl_key,
  $ssl_verify_client = $ldap::params::server_ssl_verify_client,
  $kerberos          = $ldap::params::server_kerberos,
  $krb5_keytab       = $ldap::params::server_krb5_keytab,
  $krb5_ticket_cache = $ldap::params::server_krb5_ticket_cache,
  $config           = $ldap::params::config,
  $monitor          = $ldap::params::monitor,
  $bind_anon        = $ldap::params::server_bind_anon,
  $bind_v2          = $ldap::params::server_bind_v2,
  $package_name     = $ldap::params::server_package_name,
  $package_ensure   = $ldap::params::server_package_ensure,
  $service_manage   = $ldap::params::server_service_manage,
  $service_name     = $ldap::params::server_service_name,
  $service_enable   = $ldap::params::server_service_enable,
  $service_ensure   = $ldap::params::server_service_ensure,
  $config_directory = $ldap::params::ldap_config_directory,
  $dynconfig_directory = $ldap::params::server_dynconfig_directory,
  $purge_dynconfig_dir = $ldap::params::purge_dynconfig_dir,
  $config_file      = $ldap::params::server_config_file,
  $config_template  = $ldap::params::server_config_template,
  $default_file     = $ldap::params::server_default_file,
  $default_template = $ldap::params::server_default_template,
  $db_config_file     = $ldap::params::server_db_config_file,
  $db_config_template = $ldap::params::server_db_config_template,
  $gem_name         = $ldap::params::gem_name,
  $gem_ensure       = $ldap::params::gem_ensure,
  $ldapowner        = $ldap::params::ldapowner,
  $ldapgroup        = $ldap::params::ldapgroup,
) inherits ldap::params {

  include stdlib

  validate_string($suffix)
  validate_string($rootdn)
  validate_string($rootpw)
  validate_absolute_path($directory)
  validate_re($backend, ['bdb', 'hdb', 'mdb'])
  validate_string($log_level)
  validate_array($schemas)
  validate_array($extra_schemas)
  validate_absolute_path($schema_directory)
  validate_absolute_path($config_directory)
  validate_string($schema_source_directory)
  validate_bool($purge_dynconfig_dir)
  if ($purge_dynconfig_dir) {
    validate_absolute_path($dynconfig_directory)
  }
  validate_array($modules)
  validate_array($indexes)
  validate_array($overlays)

  validate_bool($ssl)
  if $ssl == true {
    validate_absolute_path($ssl_cacert)
    # RedHat is linked against Mozilla NSS.
    # $ssl_ca is pointing to the cert db directory, /etc/openldap/certs
    # $ssl_cert is the name of the server certificate in that db, "OpenLDAP Server"
    # $ssl_key is file containing the password for the db, /etc/openldap/certs/password
    if $::osfamily != 'RedHat' {
      validate_absolute_path($ssl_cert)
    }
    validate_absolute_path($ssl_key)
    if $ssl_verify_client {
      # use tr[u]e re to work around lint warning "quoted boolean value found"
      validate_re($ssl_verify_client, ['never', 'allow', 'try', 'demand', 'hard', 'tr[u]e'])
    }
  }

  validate_bool($kerberos)
  if $kerberos {
    validate_string($krb5_keytab)
    validate_string($krb5_ticket_cache)
  }
  validate_bool($bind_anon)
  validate_bool($bind_v2)

  validate_array($access)

  # if sync provider is given, make access readonly by default but allow override
  # via parameter using e.g. hiera lookup hierarchy
  $access_writeable_on_sync_provider_only_cfg =
    $access_writeable_on_sync_provider_only ? {
    default => $access_writeable_on_sync_provider_only,
    undef => $sync_provider ? {
      default => 'read',
      undef => 'write',
    }
  }
  if $access_writeable_on_sync_provider_only_cfg {
    validate_string($access_writeable_on_sync_provider_only_cfg)
  }

  # use what was determined for consumer writeablility above for ldap root
  # access by default but allow override via parameter
  $access_for_ldapi_rootdn_cfg = $access_for_ldapi_rootdn ? {
    default => $access_for_ldapi_rootdn,
    undef => $access_writeable_on_sync_provider_only_cfg,
  }
  if $access_for_ldapi_rootdn_cfg {
    validate_string($access_for_ldapi_rootdn_cfg)
  }

  anchor { 'ldap::server::begin': } ->
  class { '::ldap::server::install': } ->
  class { '::ldap::server::config': } ~>
  class { '::ldap::server::service': } ->
  anchor { 'ldap::server::end': }
}
