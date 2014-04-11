# == Class: ldap::server
#
# Module to install and manage an ldap server
class ldap::server (
  $package_name    = $ldap::params::server_package_name,
  $package_ensure  = $ldap::params::server_package_ensure,
  $service_manage  = $ldap::params::server_service_manage,
  $service_name    = $ldap::params::server_service_name,
  $service_enable  = $ldap::params::server_service_enable,
  $service_ensure  = $ldap::params::server_service_ensure,
  $config_file     = $ldap::params::server_config_file,
  $config_template = $ldap::params::server_config_template,
  $log_level       = $ldap::params::server_log_level,
  $schemas         = $ldap::params::server_schemas,
  $modules         = $ldap::params::server_modules,
  $indexes         = $ldap::params::server_indexes,
  $ssl             = $ldap::params::server_ssl,
  $ssl_ca          = $ldap::params::server_ssl_ca,
  $ssl_cert        = $ldap::params::server_ssl_cert,
  $ssl_key         = $ldap::params::server_ssl_key,
  $directory       = $ldap::params::server_directory,
  $rootdn          = $ldap::params::server_rootdn,
  $suffix,
  $rootpw
) inherits ldap::params {

  anchor { 'ldap::server::begin': } ->
  class { '::ldap::server::install': } ->
  class { '::ldap::server::config': } ~>
  class { '::ldap::server::service': } ->
  anchor { 'ldap::server::end': }
}
