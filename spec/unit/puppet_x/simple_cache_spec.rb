# frozen_string_literal: true

require 'spec_helper'
require 'puppet_x/simple_cache'

describe PuppetX::SimpleCache do
  let(:cache_identifier) { 'testing' }
  let(:cache_data) { 'Data to cache' }

  around do |example|
    Dir.mktmpdir('rspec-') do |dir|
      @temp_dir = dir
      example.run
    end
  end

  attr_reader :temp_dir

  describe 'with defaults' do
    it do
      expect(described_class.cache_data(cache_identifier, cache_path: temp_dir) { cache_data }).to eq(cache_data)
      expect(described_class.cache_data(cache_identifier, cache_path: temp_dir) { 'another value' }).to eq(cache_data)
    end
  end

  describe 'after cache time-out' do
    it do
      expect(described_class.cache_data(cache_identifier, cache_path: temp_dir) { cache_data }).to eq(cache_data)
      expect(described_class.cache_data(cache_identifier, duration: 10, cache_path: temp_dir) { 'another value' }).to eq(cache_data)

      expect(described_class.cache_data(cache_identifier, duration: -1, cache_path: temp_dir) { 'another value' }).not_to eq(cache_data)
    end
  end

  describe 'metadata handling' do
    it do
      expect(described_class.cache_data(cache_identifier, cache_path: temp_dir) do |meta|
        meta['key'] = 'value'
        cache_data
      end).to eq(cache_data)

      # Expect metadata to be passed along
      extracted_meta = nil
      expect(described_class.cache_data(cache_identifier, duration: -1, cache_path: temp_dir) do |meta|
        extracted_meta = meta['key']
        cache_data
      end).to eq(cache_data)
      expect(extracted_meta).to eq('value')
    end

    it do
      expect(described_class.cache_data(cache_identifier, cache_path: temp_dir) { cache_data }).to eq(cache_data)
      expect(described_class.cache_data(cache_identifier, cache_path: temp_dir) do |meta|
        meta['keep'] = true
        'another value'
      end).to eq(cache_data)

      # Allow keeping outdated cache values, for use with etag/304 and similar
      expect(described_class.cache_data(cache_identifier, duration: -1, cache_path: temp_dir) do |meta|
        meta['keep'] = true
        'another value'
      end).to eq(cache_data)
    end
  end
end
