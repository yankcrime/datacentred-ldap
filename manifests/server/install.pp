# == Class: ldap::server::install
#
# Manage the installation of the ldap server package
#
class ldap::server::install inherits ldap::server {
  package { 'ldap-server':
    ensure => $ldap::server::package_ensure,
    name   => $ldap::server::package_name,
  }
}
