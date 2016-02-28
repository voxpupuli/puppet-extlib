#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe 'resources_deep_merge' do
  let(:resources) do
    {
      'one' => {
        'attributes' => {
          'user' => '1',
          'pass' => '1'
        }
      },
      'two' => {
        'attributes' => {
          'user' => '2',
          'pass' => '2'
        }
      }
    }
  end

  let(:defaults) do
    {
      'ensure' => 'present',
      'attributes' => {
        'type' => 'psql'
      }
    }
  end

  let(:result) do
    {
      'one' => {
        'ensure' => 'present',
        'attributes' => {
          'type' => 'psql',
          'user' => '1',
          'pass' => '1'
        }
      },
      'two' => {
        'ensure' => 'present',
        'attributes' => {
          'type' => 'psql',
          'user' => '2',
          'pass' => '2'
        }
      }
    }
  end

  describe 'signature validation' do
    it 'should exist' do
      is_expected.not_to be_nil
    end

    it 'should raise an ArgumentError if there is less than 1 arguments' do
      is_expected.to run.with_params.and_raise_error ArgumentError
    end

    it 'should not compile when 1 argument is passed' do
      my_hash = { 'one' => 1 }
      is_expected.to run.with_params(my_hash).and_raise_error ArgumentError
    end

    it 'should require all parameters are hashes' do
      is_expected.to run.with_params({}, '2').and_raise_error ArgumentError
    end
  end

  describe 'when calling resources_deep_merge on a resource and a defaults hash' do
    it 'should be able to deep_merge a resource hash and a defaults hash' do
      is_expected.to run.with_params(resources, defaults).and_return(result)
    end
  end
end
