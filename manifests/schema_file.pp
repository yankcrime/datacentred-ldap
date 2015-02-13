# == Type ldap::schema_file
#
# Import extra schema files from the master
#
define ldap::schema_file ($directory, $schema = $title) {
  file { "${directory}/${schema}.schema":
    owner  => 0,
    group  => 0,
    mode   => '0644',
    source => "puppet:///modules/ldap/schema/${schema}.schema",
  }
}
