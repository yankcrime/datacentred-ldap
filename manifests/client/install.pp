# == Class: ldap::client::install
#
# Manage the installation of the ldap client package
#
class ldap::client::install inherits ldap::client {
  package { 'ldap-client':
    ensure => $ldap::client::package_ensure,
    name   => $ldap::client::package_name,
  }

  package { 'net-ldap':
    ensure   => $ldap::client::gem_ensure,
    name     => $ldap::client::gem_name,
    provider => 'gem',
  }
}
