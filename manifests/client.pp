# == Class: ldap::client
#
# Module to install and manage the ldap client
class ldap::client (
  $uri,
  $base,
  $package_name     = $ldap::params::client_package_name,
  $package_ensure   = $ldap::params::client_package_ensure,
  $config_file      = $ldap::params::client_config_file,
  $config_template  = $ldap::params::client_config_template,
  $ssl              = $ldap::params::client_ssl,
  $ssl_cert         = $ldap::params::client_ssl_cert,
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
