require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts
# From https://gist.github.com/stefanozanella/4190920
# Make stdlib (i.e. its functions) available to rspec so our own functions that
# require stdlib functions can load them.
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'fixtures', 'modules', 'stdlib', 'lib')

FIXTURES_PATH = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |configuration|
  configuration.mock_with :rspec do |c|
    c.syntax = :expect
  end
end
