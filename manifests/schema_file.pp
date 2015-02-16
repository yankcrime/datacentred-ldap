# == Type ldap::schema_file
#
# Import extra schema files from the master
#
define ldap::schema_file ($directory,
  $schema = $title,
  $source = undef,
  $source_directory = 'puppet:///files/ldap/schema',
) {
  if $source {
    $schema_source = $source
  } else {
    $schema_source = "${source_directory}/${schema}.schema"
  }

  file { "${directory}/${schema}.schema":
    owner  => 0,
    group  => 0,
    mode   => '0644',
    source => $schema_source,
  }
}
