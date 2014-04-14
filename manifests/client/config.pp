# == Class: ldap::client::config
#
# Manage the configuration of the ldap client
#
class ldap::client::config inherits ldap::client {
  file { $ldap::client::config_file:
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template($ldap::client::config_template),
  }
}
