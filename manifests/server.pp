# == Class: ldap::server
#
# Module to install and manage an ldap server
class ldap::server (
  $suffix,
  $rootdn,
  $rootpw,
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
  $bind_anon       = $ldap::params::server_anon_bind
) inherits ldap::params {

  # If SSL is defined, ensure ca, cert and key are passed
  if $ssl == true {
    if $ssl_ca == undef or $ssl_cert == undef or $ssl_key == undef {
      fail('ssl_ca, ssl_cert and ssl_key are all required when ssl is enabled')
    }
  }

  anchor { 'ldap::server::begin': } ->
  class { '::ldap::server::install': } ->
  class { '::ldap::server::config': } ~>
  class { '::ldap::server::service': } ->
  anchor { 'ldap::server::end': }
}
