# == Type ldap::schema_file
#
# Import extra schema files from the master
#
define ldap::schema_file ($schema = $title, $directory) {
  file { "${directory}/$schema.schema":
    owner   => 0,
    group   => 0,
    mode    => '0644',
    source  => "puppet:///modules/ldap/schema/$schema.schema",
  }
}
