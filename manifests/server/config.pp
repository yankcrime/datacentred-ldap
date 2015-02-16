# == Class: ldap::server::config
#
# Manage the configuration of the ldap server service
#
class ldap::server::config inherits ldap::server {
  file { $ldap::server::config_file:
    owner   => $ldap::server::ldapowner,
    group   => $ldap::server::ldapgroup,
    # may contain passwords
    mode    => '0400',
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

  file { $ldap::server::schema_directory:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0755',
  }
  ->
  ldap::schema_file { $ldap::server::extra_schemas:
    directory        => $ldap::server::schema_directory,
    source_directory => $ldap::server::schema_source_directory,
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

  if $ldap::server::dynconfig_directory and $ldap::server::purge_dynconfig_directory == true {
    file { $ldap::server::dynconfig_directory:
      ensure  => absent,
      path    => $ldap::server::dynconfig_directory,
      recurse => true,
      purge   => true,
      force   => true,
    }
  }
}
