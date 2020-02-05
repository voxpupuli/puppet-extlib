require 'spec_helper'
require 'puppet'

describe 'puppet_config' do
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

  it do
    expect(Facter.fact(:extlib).value).to include('puppet_config' => settings)
  end
end
