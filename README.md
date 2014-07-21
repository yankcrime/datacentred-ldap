#LDAP

[![Build Status](https://travis-ci.org/datacentred/datacentred-ldap.png?branch=master)](https://travis-ci.org/datacentred/datacentred-ldap)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Testing - Guide for contributing to the module](#testing)

## Overview

The LDAP module installs, configures, and manages the LDAP client and SLAPD server.

## Module Description

The LDAP module manages both the installation and configuration of the LDAP client and SLAPD service, as
well as extends Puppet to allow management of LDAP resources, such as database structure.

## Usage

#### LDAP Client (`ldap::client`)

Basic LDAP client configuration

    class { 'ldap::client':
      uri  => 'ldap://ldapserver01 ldap://ldapserver02',
      base => 'dc=example,dc=com',
    }

This will install the required packages and LDAP configuration.

##### Enable TLS/SSL:

Note: This module does not manage SSL certificates for you, and assumes the files specified already exist on the system (i.e. via an SSL cert management module)

    class { 'ldap::client':
      uri      => 'ldaps://ldapserver01 ldaps://ldapserver02',
      base     => 'dc=example,dc=com',
      ssl      => true,
      ssl_cert => '/etc/ssl/certs/ldapserver.pem'
    }

### LDAP Server (`ldap::server`)

Basic LDAP server configuration

    class { 'ldap::server':
      suffix  => 'dc=example,dc=com',
      rootdn  => 'cn=admin,dc=example,dc=com',
      rootpw  => 'llama',
    }

##### Enable TLS/SSL:

Note: This module does not manage SSL certificates for you, and assumes the files specified already exist on the system (i.e. via an SSL cert management module)

    class { 'ldap::server':
      suffix     => 'dc=example,dc=com',
      rootdn     => 'cn=admin,dc=example,dc=com',
      rootpw     => 'llama',
      ssl        => true,
      ssl_cacert => '/etc/ssl/certs/ca.pem',
      ssl_cert   => '/etc/ssl/certs/ldapserver.crt',
      ssl_key    => '/etc/ssl/private/ldapserver.key',
    }

#### Hiera example

Both the `ldap::client` and `ldap::server` module support data bindings from hiera, using the following example:

    ldap::client::uri: 'ldaps://ldapserver01 ldaps://ldapserver02'
    ldap::client::base: 'dc=example,dc=com'
    ldap::client::ssl: true
    ldap::client::ssl_cert: '/etc/ssl/certs/ldapserver.pem'

    ldap::server::suffix: 'dc=example,dc=com'
    ldap::server::rootdn: 'cn=admin,dc=example,dc=com'
    ldap::server::rootpw: 'llama'
    ldap::server::ssl: true
    ldap::server::ssl_cacert: '/etc/ssl/certs/ca.pem'
    ldap::server::ssl_cert: '/etc/ssl/certs/ldapserver.crt'
    ldap::server::ssl_key: '/etc/ssl/private/ldapserver.key'

### Adding Entries to an LDAP server

It's possible to use Puppet to maintain an LDAP schema and entries using the following custom type.

```puppet
ldap_entry { 'cn=Foo,ou=Bar,dc=baz,dc=co,dc=uk':
  ensure      => present,
  host        => '1.2.3.4',
  port        => 636,
  base        => 'dc=baz,dc=co,dc=uk',
  username    => 'cn=admin,dc=baz,dc=co,dc=uk',
  password    => 'password',
  attributes  => { givenName   => 'Foo',
                   objectClass => ["top", "person", "inetorgPerson"]}
}

ldap_entry { 'cn=Foo,ou=Bar,dc=baz,dc=co,dc=uk':
  ensure      => absent,
  base        => 'dc=baz,dc=co,dc=uk',
  host        => '1.2.3.4',
  username    => 'cn=admin,dc=baz,dc=co,dc=uk',
  password    => 'password',
}
```

Please note that password entries need to be hashed before being passed to LDAP. You may use the puppet function `sha1digest` (see the Functions section below) or another hashing scheme such as MD5 or libcrypt. These will appear as `"{MD5}ghGY787GHvh8Uhj"` or `"{CRYPT}$6$hG7Ggh$hjhjkHUGYU67hgGt67h01hdsghGH"`, respectively.

#### Hiera example

`ldap_entry` resources can be created from Hiera using `create_resources`. 

```yaml
---
# LDAP Test

ldap::entries:
  "%{dn}":
    attributes:
      dc: %dc
      objectClass:
        - top
        - domain
      description: 'Tree root'
  "ou=users,%{dn}":
    attributes:
      ou: 'users'
      objectClass:
        - top
        - organizationalUnit
      description: "Users for %{dn}"
  "ou=groups,%{dn}":
    attributes:
      ou: 'groups'
      objectClass:
        - top
        - organizationalUnit
      description: "Groups for %{dn}"
  "cn=user,ou=users,%{dn}":
    attributes:
      cn: 'user'
      objectClass:
        - top
        - person
        - organizationalPerson
        - inetOrgPerson
      uid: 'user'
      sn: 'user'
      userPassword: %{password}
```

You can then create the resources using the following Puppet code:
```puppet
$dn = domain2dn("$::domain")

$ldap_defaults = {
  ensure => present,
  base   => $dn,
  host   => 'localhost',
  port   => 389,
  ssl    => false,
  username => "cn=admin,${dn}",
  password => 'password'
}

$password = sha1digest("password")

$ldap_entries = hiera_hash('ldap::entries')
create_resources('ldap_entry',$ldap_entries,$ldap_defaults)
```

### Functions

#### Hash a password with SHA-1 Digest

```ruby
sha1digest("secret") # => "{SHA}5en6G6MezRroT3XKqkdPOmY/BfQ="
```

#### Convert a dotted domain to a DN format suitable for LDAP

```ruby
domain2dn("test.domain") # => "dc=test,dc=domain"
```

### Limitations

This module should work across all versions of Debian/Ubuntu. Pull requests gladly accepted.

Note that the `ldap_entry` provider uses the net/ldap gem and requires Ruby 1.9.3 to be installed on the system running the manifest.

### Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/) and [beaker-rspec](https://github.com/puppetlabs/beaker-rspec) to verify functionality. For in-depth information please see their respective documentation.

Quickstart:

    gem install bundler
    bundle install
    bundle exec rake spec
    bundle exec rspec spec/acceptance
