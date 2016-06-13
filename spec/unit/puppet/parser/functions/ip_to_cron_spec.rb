require 'spec_helper'

describe 'ip_to_cron', type: :puppet_function do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'exists' do
    expect(Puppet::Parser::Functions.function('ip_to_cron')).to eq('function_ip_to_cron')
  end
end
