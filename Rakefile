require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# Blacksmith borks on ruby 1.8.7
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

# Ensure we fail the tests on lint warnings
PuppetLint.configuration.log_format       = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.fail_on_warnings = true

# Forsake support for Puppet 2.6.2 for the benefit of cleaner code.
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_80chars')

# Tests should include syntax, lint and rspec
desc 'Run syntax, lint, and spec tests.'
task :test => [
  :syntax,
  :lint,
  :spec,
]
