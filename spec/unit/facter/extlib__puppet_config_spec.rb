require 'spec_helper'
require 'puppet'

describe 'extlib__puppet_config fact' do
  let(:hostname) { Puppet[:certname] }
  let(:settings) do
    {
      'main' => {
        'hostcert' => "/dev/null/ssl/certs/#{hostname}.pem",
        'hostprivkey' => "/dev/null/ssl/private_keys/#{hostname}.pem",
        'hostpubkey' => "/dev/null/ssl/public_keys/#{hostname}.pem",
        'localcacert' => '/dev/null/ssl/certs/ca.pem',
        'server' => 'puppet',
        'ssldir' => '/dev/null/ssl',
        'vardir' => '/dev/null'
      },
      'master' => {
        'localcacert' => '/dev/null/ssl/certs/ca.pem',
        'ssldir' => '/dev/null/ssl'
      }
    }
  end

  it { expect(Facter.fact(:extlib__puppet_config).value).to eq(settings) }

  if Gem::Version.new(Gem.loaded_specs['facter'].version) >= Gem::Version.new('4')
    it 'is also available under the toplevel `extlib` structured fact' do
      expect(Facter.fact(:extlib).value).to include('puppet_config' => settings)
    end
  end
end
