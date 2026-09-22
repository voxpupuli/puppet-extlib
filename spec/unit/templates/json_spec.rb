# frozen_string_literal: true

require 'spec_helper'

describe 'test_json', type: :class do
  let(:pre_condition) do
    <<~PUPPET
      class test_json (
        Boolean $pretty = false,
        Boolean $sort_keys = false,
      ) {
        $content = epp('extlib/json.epp', {
          'data'      => { 'b' => 2, 'a' => 1 },
          'pretty'    => $pretty,
          'sort_keys' => $sort_keys,
        })

        file { '/tmp/test-json':
          ensure  => file,
          content => $content,
        }

        $sensitive_content = epp('extlib/json.epp', {
          'data'   => { 'password' => Sensitive('secret') },
          'pretty' => false,
        })

        file { '/tmp/test-json-sensitive':
          ensure  => file,
          content => $sensitive_content,
        }
      }
    PUPPET
  end

  context 'default compact rendering' do
    it 'renders compact JSON with a trailing newline' do
      is_expected.to contain_file('/tmp/test-json').with_content("{\"b\":2,\"a\":1}\n")
    end
  end

  context 'pretty rendering' do
    let(:params) { { 'pretty' => true } }

    it 'renders pretty JSON' do
      is_expected.to contain_file('/tmp/test-json').with_content(<<~JSON)
        {
          "b": 2,
          "a": 1
        }
      JSON
    end
  end

  context 'with sensitive values' do
    it 'renders sensitive values as plain text' do
      is_expected.to contain_file('/tmp/test-json-sensitive').with_content("{\"password\":\"secret\"}\n")
    end
  end

  context 'with sort_keys enabled' do
    let(:params) { { 'sort_keys' => true } }

    it 'renders compact JSON with keys in sorted order' do
      is_expected.to contain_file('/tmp/test-json').with_content("{\"a\":1,\"b\":2}\n")
    end
  end

  context 'with sort_keys enabled and pretty rendering' do
    let(:params) { { 'pretty' => true, 'sort_keys' => true } }

    it 'renders pretty JSON with keys in sorted order' do
      is_expected.to contain_file('/tmp/test-json').with_content(<<~JSON)
        {
          "a": 1,
          "b": 2
        }
      JSON
    end
  end
end
