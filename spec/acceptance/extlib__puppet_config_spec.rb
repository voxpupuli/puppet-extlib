# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'extlib__puppet_config fact' do
  let(:puppet_config) { fact('extlib__puppet_config') }

  it 'reports confdir' do
    expect(puppet_config['confdir']).to eq(on(default, 'puppet config print confdir').stdout.strip)
  end

  {
    'main' => %w[hostpubkey hostprivkey hostcert localcacert ssldir vardir server environment],
    'master' => %w[localcacert ssldir],
    'agent' => %w[environment],
  }.each do |section, settings|
    it "reports the #{section} settings that puppet config print does" do
      expected = settings.to_h do |setting|
        [setting, on(default, "puppet config print #{setting} --section #{section}").stdout.strip]
      end
      expect(puppet_config[section]).to eq(expected)
    end
  end
end
