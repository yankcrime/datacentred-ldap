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
# [*log_level*]
#   Daemon logging level, see http://www.openldap.org/doc/admin24/slapdconfig.html.
#
# [*schemas*]
#   An array of schema files which should be loaded in.
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
# [*ssl_ca*]
#   Path to the certificate authority file for the LDAP SSL certificate.
#
# [*ssl_cert*]
#   Path to the SSL certificate file.
#
# [*ssl_key*]
#   Path to the SSL certificate key.
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
  $directory        = $ldap::params::server_directory,
  $log_level        = $ldap::params::server_log_level,
  $schemas          = $ldap::params::server_schemas,
  $modules          = $ldap::params::server_modules,
  $indexes          = $ldap::params::server_indexes,
  $overlays         = $ldap::params::server_overlays,
  $ssl              = $ldap::params::server_ssl,
  $ssl_ca           = $ldap::params::server_ssl_ca,
  $ssl_cert         = $ldap::params::server_ssl_cert,
  $ssl_key          = $ldap::params::server_ssl_key,
  $bind_anon        = $ldap::params::server_bind_anon,
  $bind_v2          = $ldap::params::server_bind_v2,
  $package_name     = $ldap::params::server_package_name,
  $package_ensure   = $ldap::params::server_package_ensure,
  $service_manage   = $ldap::params::server_service_manage,
  $service_name     = $ldap::params::server_service_name,
  $service_enable   = $ldap::params::server_service_enable,
  $service_ensure   = $ldap::params::server_service_ensure,
  $config_file      = $ldap::params::server_config_file,
  $config_template  = $ldap::params::server_config_template,
  $default_file     = $ldap::params::server_default_file,
  $default_template = $ldap::params::server_default_template,
  $gem_name         = $ldap::params::gem_name,
  $gem_ensure       = $ldap::params::gem_ensure,

) inherits ldap::params {

  include stdlib

  validate_string($suffix)
  validate_string($rootdn)
  validate_string($rootpw)
  validate_absolute_path($directory)
  validate_string($log_level)
  validate_array($schemas)
  validate_array($modules)
  validate_array($indexes)
  validate_array($overlays)
  validate_bool($ssl)
  if $ssl == true {
    validate_absolute_path($ssl_ca)
    validate_absolute_path($ssl_cert)
    validate_absolute_path($ssl_key)
  }
  validate_bool($bind_anon)
  validate_bool($bind_v2)

  anchor { 'ldap::server::begin': } ->
  class { '::ldap::server::install': } ->
  class { '::ldap::server::config': } ~>
  class { '::ldap::server::service': } ->
  anchor { 'ldap::server::end': }
}
