# == Class: ldap::server::config
#
# Manage the configuration of the ldap server service
#
class ldap::server::config inherits ldap::server {
  file { $ldap::server::config_file:
    owner   => $ldap::server::ldapowner,
    group   => $ldap::server::ldapgroup,
    mode    => '0644',
    content => template($ldap::server::config_template),
  }

  if $ldap::server::default_file {
    file { $ldap::server::default_file:
      owner   => 0,
      group   => 0,
      mode    => '0644',
      content => template($ldap::server::default_template),
    }
  }

  file { $ldap::server::db_config_file:
    owner   => $ldap::server::ldapowner,
    group   => $ldap::server::ldapgroup,
    mode    => '0644',
    content => template($ldap::server::db_config_template),
  }
}
