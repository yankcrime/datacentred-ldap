# == Class: ldap::client::install
#
# Manage the installation of the ldap client package
#
class ldap::client::install inherits ldap::client {
  package { 'ldap-client':
    ensure => $ldap::client::package_ensure,
    name   => $ldap::client::package_name,
  }

  if $ldap::client::manage_package_dependencies {
    package { 'ruby':
      ensure => present,
    } ->

    package { 'net-ldap':
      ensure   => $ldap::client::net_ldap_package_ensure,
      name     => $ldap::client::net_ldap_package_name,
      provider => $ldap::client::net_ldap_package_provider,
    }
  }
}
