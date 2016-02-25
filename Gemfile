source "https://rubygems.org"

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 4.2.0'
  gem 'rspec-puppet'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint'
  gem 'rspec-puppet-facts'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'vagrant-wrapper'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-rspec'
end

# Constrain the net-ldap gem on ruby 1.9.3 systems
if Gem::Version.new(/\d+\.\d+\.\d+/.match(%x{ruby --version})) == Gem::Version.new('1.9.3')
  net_ldap_gem = [ '>=0.10.0', '<0.13.0' ]
else
  net_ldap_gem = [ '>=0.13.0' ]
end

group :production do
  gem 'net-ldap', *net_ldap_gem
end 
