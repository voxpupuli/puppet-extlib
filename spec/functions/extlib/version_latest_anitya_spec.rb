# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::version_latest_anitya' do
  let(:anitya_project) { 4223 }
  let(:anitya_output) do
    {
      latest_version: '3.4.6',
      stable_versions: [
        '3.4.6', '3.4.5', '3.4.4', '3.4.3', '3.4.2', '3.4.1', '3.4.0', '3.3.9', '3.3.8', '3.3.7', '3.3.6', '3.3.5', '3.3.4', '3.3.3', '3.3.2', '3.3.1', '3.3.0', '3.2.9', '3.2.8', '3.2.7'
      ],
      versions: [
        '3.4.6', '3.4.5', '3.4.4', '3.4.3', '3.4.2', '3.4.1', '3.4.0', '3.3.9', '3.3.8', '3.3.7', '3.3.6', '3.3.5', '3.3.4', '3.3.3', '3.3.2', '3.3.1', '3.3.0', '3.3.0-rc1', '3.3.0-preview3', '3.3.0-preview2'
      ]
    }
  end

  before do
    response_double = instance_double(Net::HTTPResponse)
    allow(Net::HTTP).to receive(:get_response).with(URI('https://release-monitoring.org/api/v2/versions/?project_id=4223')).and_return(response_double)
    allow(response_double).to receive(:value)
    allow(response_double).to receive(:body).and_return(anitya_output.to_json)

    # Disable writing the cache files
    allow(FileUtils).to receive(:mkdir_p)
    allow(File).to receive(:open)
    allow(File).to receive(:chown)
  end

  context 'for ruby latest' do
    it { is_expected.to run.with_params(anitya_project).and_return('3.4.6') }
  end

  context 'for ruby 3' do
    let(:anitya_range) { SemanticPuppet::VersionRange.parse('~3') }

    it { is_expected.to run.with_params(anitya_project, anitya_range).and_return('3.4.6') }
  end

  context 'for ruby 3.2' do
    let(:anitya_range) { SemanticPuppet::VersionRange.parse('~3.2') }

    it { is_expected.to run.with_params(anitya_project, anitya_range).and_return('3.2.9') }
  end

  context 'for non-existant ruby 42.0' do
    let(:anitya_range) { SemanticPuppet::VersionRange.parse('~42.0') }

    it { is_expected.to run.with_params(anitya_project, anitya_range).and_raise_error(RuntimeError, 'No stable versions found that matches ~42.0') }
  end
end
