# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::resources_deep_merge' do
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
    it 'exists' do
      expect(subject).not_to be_nil
    end

    it 'raises an ArgumentError if there is less than 1 arguments' do
      expect(subject).to run.with_params.and_raise_error ArgumentError
    end

    it 'does not compile when 1 argument is passed' do
      my_hash = { 'one' => 1 }
      expect(subject).to run.with_params(my_hash).and_raise_error ArgumentError
    end

    it 'requires all parameters are hashes' do
      expect(subject).to run.with_params({}, '2').and_raise_error ArgumentError
    end
  end

  describe 'when calling resources_deep_merge on a resource and a defaults hash' do
    it 'is able to deep_merge a resource hash and a defaults hash' do
      expect(subject).to run.with_params(resources, defaults).and_return(result)
    end
  end
end
