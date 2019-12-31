require 'spec_helper'
require 'puppet'

hostname = Puppet[:certname]
settings = {
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
describe 'puppet_config' do
  context 'when puppet' do
    it 'puppet_config' do
      expect(Facter.fact(:puppet_config).value).to eq(settings)
    end
  end
end
