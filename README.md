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

#### LDAP Client (`ldap`)

Basic LDAP client configuration

    class { 'ldap':
      uri  => 'ldap://ldapserver01 ldap://ldapserver02',
      base => 'dc=example,dc=com',
    }

This will install the required packages and LDAP configuration.

##### Enable TLS/SSL:

Note: This module does not manage SSL certificates for you, and assumes the files specified already exist on the system (i.e. via an SSL cert management module)

    class { 'ldap':
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
      suffix   => 'dc=example,dc=com',
      rootdn   => 'cn=admin,dc=example,dc=com',
      rootpw   => 'llama',
      ssl      => true,
      ssl_ca   => '/etc/ssl/certs/ca.pem',
      ssl_cert => '/etc/ssl/certs/ldapserver.crt',
      ssl_key  => '/etc/ssl/private/ldapserver.key',
    }

#### Hiera example

Both the `ldap` and `ldap::server` module support data bindings from hiera, using the following example:

    ldap::uri: 'ldaps://ldapserver01 ldaps://ldapserver02'
    ldap::base: 'dc=example,dc=com'
    ldap::ssl: true
    ldap::ssl_cert: '/etc/ssl/certs/ldapserver.pem'

    ldap::server::suffix: 'dc=example,dc=com'
    ldap::server::rootdn: 'cn=admin,dc=example,dc=com'
    ldap::server::rootpw: 'llama'
    ldap::server::ssl: true
    ldap::server::ssl_ca: '/etc/ssl/certs/ca.pem'
    ldap::server::ssl_cert: '/etc/ssl/certs/ldapserver.crt'
    ldap::server::ssl_key: '/etc/ssl/private/ldapserver.key'

### Limitations

This module should work across all versions of Debian/Ubuntu. Pull requests gladly accepted

### Testing

This project contains tests for [rspec-puppet](http://rspec-puppet.com/) to verify functionality. For in-depth information please see their respective documentation.

Quickstart:

    gem install bundler
    bundle install
    bundle exec rake test
