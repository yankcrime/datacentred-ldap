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

  file { $ldap::server::directory:
    ensure => directory,
    owner  => $ldap::server::ldapowner,
    group  => $ldap::server::ldapgroup,
    mode   => '0700',
  }

  if $ldap::server::backend == 'bdb' or $ldap::server::backend == 'hdb' {
    file { $ldap::server::db_config_file:
      owner   => $ldap::server::ldapowner,
      group   => $ldap::server::ldapgroup,
      mode    => '0644',
      content => template($ldap::server::db_config_template),
      require => File[$ldap::server::directory],
    }
  }
}
