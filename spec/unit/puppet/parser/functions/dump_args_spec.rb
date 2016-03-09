require 'spec_helper'
require 'json'
describe 'dump_args' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('dump_args')).to eq('function_dump_args')
  end
end
