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
#   Whether the client should attempt to connect over SSL.
#
# [*ssl_cert*]
#   Path to the SSL certificate file.
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
  $ssl_cert         = $ldap::params::client_ssl_cert,
  $package_name     = $ldap::params::client_package_name,
  $package_ensure   = $ldap::params::client_package_ensure,
  $config_file      = $ldap::params::client_config_file,
  $config_template  = $ldap::params::client_config_template,
  $gem_name         = $ldap::params::gem_name,
  $gem_ensure       = $ldap::params::gem_ensure,
) inherits ldap::params {

  # If SSL is defined, ensure cert is passed
  if ($ssl == true) and ($ssl_cert == undef) {
    fail('ssl_cert is required when ssl is enabled')
  }

  anchor { 'ldap::client::begin': } ->
  class { '::ldap::client::install': } ->
  class { '::ldap::client::config': } ->
  anchor { 'ldap::client::end': }
}
