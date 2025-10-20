# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::version_latest_github' do
  let(:github_project) { 'OpenVoxProject/openvox' }
  let(:github_output) do
    [
      # Trimmed to minimal size, for testing purposes
      { tag_name: '8.23.1' },
      { tag_name: '8.23.0' },
      { tag_name: '8.22.0' },
      { tag_name: '8.21.1' },
      { tag_name: '8.21.0' },
      { tag_name: '8.20.0' },
      { tag_name: '8.19.2' },
      { tag_name: '7.37.2' },
      { tag_name: '8.19.1' },
      { tag_name: '7.37.1' },
      { tag_name: '7.37.0' },
      { tag_name: '8.19.0' }
    ]
  end

  before do
    response_double = instance_double(Net::HTTPResponse)
    allow(Net::HTTP).to receive(:get_response).with(URI("https://api.github.com/repos/#{github_project}/releases"), {}).and_return(response_double)
    allow(response_double).to receive(:value)
    allow(response_double).to receive(:[]).with('etag')
    allow(response_double).to receive(:body).and_return(github_output.to_json)

    # Disable writing the cache files
    allow(FileUtils).to receive(:mkdir_p)
    allow(File).to receive(:open)
    allow(File).to receive(:chown)
  end

  context 'for openvox latest' do
    before do
      response_double = instance_double(Net::HTTPResponse)
      allow(Net::HTTP).to receive(:get_response).with(URI("https://api.github.com/repos/#{github_project}/releases/latest"), {}).and_return(response_double)
      allow(response_double).to receive(:value)
      allow(response_double).to receive(:[]).with('etag')
      allow(response_double).to receive(:body).and_return(github_output.first.to_json)
    end

    it { is_expected.to run.with_params(github_project).and_return('8.23.1') }
  end

  context 'for openvox 8.19' do
    let(:github_range) { SemanticPuppet::VersionRange.parse('~8.19') }

    it { is_expected.to run.with_params(github_project, github_range).and_return('8.19.2') }
  end

  context 'for openvox 7' do
    let(:github_range) { SemanticPuppet::VersionRange.parse('~7') }

    it { is_expected.to run.with_params(github_project, github_range).and_return('7.37.2') }
  end

  context 'for non-existant openvox 42.0' do
    let(:github_range) { SemanticPuppet::VersionRange.parse('~42.0') }

    it { is_expected.to run.with_params(github_project, github_range).and_raise_error(RuntimeError, 'No stable versions found that matches ~42.0') }
  end
end
