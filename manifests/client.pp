# == Class: ldap::client
#
#  This class manages the installation and configuration of the OpenLDAP client
#
# === Parameters
#
# [*uri*]
#   The URI to the LDAP server(s) queries should be performed against.
#
# [*base*]
#   The domain for which the LDAP server provides information for.
#
# [*ssl*]
#   Whether the client should attempt to connect over SSL (false, true).
#
# [*ssl_cacert*]
#   Name of the CA Cert (OpenSSL: a filename, MozNSS: cert name in the certdb).
#
# [*ssl_cacertdir*]
#   Directory of the CA cert file (OpenSSL: a dirname, MozNSS: dirname where the certdb is).
#
# [*ssl_cert*]
#   SSL Certificate (OpenSSL: A filename, MozNSS: a cert name in the certdb).
#
# [*ssl_key*]
#   (OpenSSL: key file matching ssl_cert, MozNSS: filename to the password file for certdb).
#
# [*ssl_reqcert*]
#   How CA validation is being handled (never, allow, try, demand).
#
# === Examples
#
#  class { 'ldap::client':
#    uri  => 'ldap://ldapserver01 ldap://ldapserver02',
#    base => 'dc=example,dc=com',
#  }
#
class ldap::client (
  $uri,
  $base,
  $ssl              = $ldap::params::client_ssl,
  $ssl_cacert       = $ldap::params::client_ssl_cacert,
  $ssl_cacertdir    = $ldap::params::client_ssl_cacertdir,
  $ssl_cert         = $ldap::params::client_ssl_cert,
  $ssl_key          = $ldap::params::client_ssl_key,
  $ssl_reqcert      = $ldap::params::client_ssl_reqcert,
  $package_name     = $ldap::params::client_package_name,
  $package_ensure   = $ldap::params::client_package_ensure,
  $config_directory = $ldap::params::ldap_config_directory,
  $config_file      = $ldap::params::client_config_file,
  $config_template  = $ldap::params::client_config_template,
  $gem_name         = $ldap::params::gem_name,
  $gem_ensure       = $ldap::params::gem_ensure,
) inherits ldap::params {

  include stdlib

  validate_string($uri)
  validate_string($base)
  validate_bool($ssl)
  if $ssl == true {
    validate_absolute_path($ssl_cacert)
    validate_absolute_path($ssl_cacertdir)
    validate_absolute_path($ssl_cert)
    validate_absolute_path($ssl_key)
    validate_absolute_path($ssl_reqcert)
  }

  anchor { 'ldap::client::begin': } ->
  class { '::ldap::client::install': } ->
  class { '::ldap::client::config': } ->
  anchor { 'ldap::client::end': }
}
