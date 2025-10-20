# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::version_latest_endoflife' do
  let(:endoflife_product) { 'kubernetes' }
  let(:endoflife_cycle) { 'latest' }
  let(:endoflife_output) do
    {
      schema_version: '1.2.0',
      generated_at: '2025-10-06T00:36:52+00:00',
      result: {
        name: '1.34',
        codename: nil,
        label: '1.34',
        releaseDate: '2025-08-27',
        isLts: false,
        ltsFrom: nil,
        isEoas: false,
        eoasFrom: nil,
        isEol: false,
        eolFrom: nil,
        isMaintained: true,
        latest: {
          name: '1.34.1',
          date: '2025-09-09',
          link: 'https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.34.md'
        },
        custom: nil
      }
    }
  end

  before do
    response_double = instance_double(Net::HTTPResponse)
    allow(Net::HTTP).to receive(:get_response).with(URI("https://endoflife.date/api/v1/products/#{endoflife_product}/releases/#{endoflife_cycle}"), {}).and_return(response_double)
    allow(response_double).to receive(:value)
    allow(response_double).to receive(:[]).with('etag')
    allow(response_double).to receive(:body).and_return(endoflife_output.to_json)

    # Disable writing the cache files
    allow(FileUtils).to receive(:mkdir_p)
    allow(File).to receive(:open)
    allow(File).to receive(:chown)
  end

  context 'for latest Kubernetes' do
    it { is_expected.to run.with_params(endoflife_product).and_return('1.34.1') }
  end

  context 'for end-of-life Kubernetes 1.30' do
    let(:endoflife_cycle) { '1.30' }
    let(:endoflife_output) do
      {
        schema_version: '1.2.0',
        generated_at: '2025-10-06T00:36:52+00:00',
        result: {
          name: '1.30',
          codename: nil,
          label: '1.30',
          releaseDate: '2024-04-17',
          isLts: false,
          ltsFrom: nil,
          isEoas: true,
          eoasFrom: '2025-04-28',
          isEol: true,
          eolFrom: '2025-06-28',
          isMaintained: false,
          latest: {
            name: '1.30.14',
            date: '2025-06-17',
            link: 'https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.30.md'
          },
          custom: nil
        }
      }
    end

    it do
      allow(Puppet).to receive(:warning).with('Latest version for kubernetes 1.30 is end-of-life since 2025-06-28')
      is_expected.to run.with_params(endoflife_product, endoflife_cycle).and_return('1.30.14')
      expect(Puppet).to have_received(:warning)
    end
  end
end
