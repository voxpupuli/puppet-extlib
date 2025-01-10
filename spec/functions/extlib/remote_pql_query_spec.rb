# frozen_string_literal: true

require 'spec_helper'
require 'puppetdb'

describe 'extlib::remote_pql_query' do
  let(:mock_client) { instance_double(PuppetDB::Client) }
  let(:mock_response) { PuppetDB::Response.new(['test_result']) }

  before do
    allow(PuppetDB::Client).to receive(:new).and_return(mock_client)
    allow(mock_client).to receive(:request).and_return(mock_response)
  end

  context 'secure_remote_pql_query' do
    it 'returns the data array for valid HTTPS params' do
      is_expected.to run.with_params(
        'facts { name = "osfamily" }',  # query
        'https://puppetdb.example.com', # URL (matches HTTPS dispatch)
        'client_key',                   # key
        'client_cert',                  # cert
        'ca_cert'                       # cacert
      ).and_return(['test_result'])
    end

    it 'raises ArgumentError if given an HTTP URL in the secure dispatch' do
      is_expected.to run.with_params(
        'facts { name = "osfamily" }',
        'http://puppetdb.example.com', # Wrong for secure dispatch
        'client_key',
        'client_cert',
        'ca_cert'
      ).and_raise_error(
        ArgumentError, %r{parameter 'url'}i
      )
    end
  end

  context 'insecure_remote_pql_query' do
    it 'returns the data array for valid HTTP params' do
      is_expected.to run.with_params(
        'facts { name = "osfamily" }', # query
        'http://puppetdb.example.com'  # URL (matches HTTP dispatch)
      ).and_return(['test_result'])
    end

    it 'raises ArgumentError if given an HTTPS URL in the insecure dispatch' do
      is_expected.to run.with_params(
        'facts { name = "osfamily" }',
        'https://puppetdb.example.com' # Wrong for insecure dispatch
      ).and_raise_error(
        ArgumentError, %r{parameter 'url'}i
      )
    end
  end

  context 'with query options' do
    it 'passes options to the client.request call' do
      allow(mock_client).to receive(:request).with(
        '',
        'resources { type = "File" }',
        { 'limit' => 5 }
      ).and_return(mock_response)

      is_expected.to run.with_params(
        'resources { type = "File" }',
        'http://puppetdb.example.com',
        { 'limit' => 5 }
      ).and_return(['test_result'])

      expect(mock_client).to have_received(:request).with(
        '',
        'resources { type = "File" }',
        { 'limit' => 5 }
      )
    end
  end

  context 'when PuppetDB::APIError is raised' do
    it 're-raises as a Puppet::Error' do
      allow(mock_client).to receive(:request).and_raise(
        PuppetDB::APIError.new(
          instance_double(PuppetDB::Response, inspect: 'some API error')
        )
      )

      is_expected.to run.with_params(
        'facts { name = "osfamily" }',
        'http://puppetdb.example.com'
      ).and_raise_error(Puppet::Error, %r{PuppetDB API Error: some API error})
    end
  end

  context 'when a generic error is raised' do
    it 're-raises as a Puppet::Error' do
      allow(mock_client).to receive(:request).and_raise(RuntimeError, 'boom')

      is_expected.to run.with_params(
        'facts { name = "osfamily" }',
        'http://puppetdb.example.com'
      ).and_raise_error(Puppet::Error, %r{Remote PQL query failed: boom})
    end
  end
end
