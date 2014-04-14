source "http://rubygems.org"

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '> 2.7.0'
  gem 'puppet-lint'
  gem 'rspec-puppet', '> 1.0.0'
  gem 'rspec-puppet-utils'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper'
end

group :development do
  gem 'travis'
  gem 'puppet-blacksmith'
end

group :production do
  gem 'net-ldap'
end 
