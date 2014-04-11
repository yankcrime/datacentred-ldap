# == Class: ldap::server::service
#
# Manage the ldap server service
#
class ldap::server::service inherits ldap::server {
  if $ldap::server::service_manage == true {
    service { 'ldap-server':
      ensure     => $ldap::server::service_ensure,
      enable     => $ldap::server::service_enable,
      name       => $ldap::server::service_name,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
