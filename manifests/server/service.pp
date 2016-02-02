# == Class: ldap::server::service
#
# Manage the ldap server service
#
class ldap::server::service inherits ldap::server {
  if $ldap::server::service_manage == true {
    # Puppet versions prior 3.6 did not have the
    # flags parameter, and Ruby versions < 2 seem to
    # be problematic in general with that parameter
    if $::osfamily == 'OpenBSD' {
      service { 'ldap-server':
        ensure     => $ldap::server::service_ensure,
        enable     => $ldap::server::service_enable,
        name       => $ldap::server::service_name,
        flags      => $ldap::server::service_flags,
        hasstatus  => true,
        hasrestart => true,
      }
    } else {
      service { 'ldap-server':
        ensure     => $ldap::server::service_ensure,
        enable     => $ldap::server::service_enable,
        name       => $ldap::server::service_name,
        hasstatus  => true,
        hasrestart => true,
      }
    }
  }
}
