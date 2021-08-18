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
end
