# frozen_string_literal: true

require 'spec_helper'

describe 'test_yaml', type: :class do
  let(:pre_condition) do
    <<~PUPPET
      class test_yaml (
        Variant[Scalar, Array, Hash] $data = {
          'b' => 2,
          'a' => { 'd' => 4, 'c' => 3 },
        },
        Optional[Variant[String, Array[String]]] $comments = undef,
        Boolean $sort_keys = false,
      ) {
        $content = epp('extlib/yaml.epp', {
          'data'      => $data,
          'comments'  => $comments,
          'sort_keys' => $sort_keys,
        })

        file { '/tmp/test-yaml':
          ensure  => file,
          content => $content,
        }

        $sensitive_content = epp('extlib/yaml.epp', {
          'data' => { 'password' => Sensitive('secret') },
        })

        file { '/tmp/test-yaml-sensitive':
          ensure  => file,
          content => $sensitive_content,
        }
      }
    PUPPET
  end

  context 'with default comments' do
    it 'renders a single leading document marker and the YAML body' do
      is_expected.to contain_file('/tmp/test-yaml').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        b: 2
        a:
          d: 4
          c: 3
      YAML
    end
  end

  context 'with custom comments' do
    let(:params) { { 'comments' => ['comment one'] } }

    it 'renders the document marker, comments, and the YAML body' do
      is_expected.to contain_file('/tmp/test-yaml').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        # comment one
        #
        b: 2
        a:
          d: 4
          c: 3
      YAML
    end
  end

  context 'with a single string comment' do
    let(:params) { { 'comments' => 'single comment' } }

    it 'renders the string as one comment' do
      is_expected.to contain_file('/tmp/test-yaml').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        # single comment
        #
        b: 2
        a:
          d: 4
          c: 3
      YAML
    end
  end

  context 'with an array as top-level data' do
    let(:params) { { 'data' => %w[one two] } }

    it 'renders the array' do
      is_expected.to contain_file('/tmp/test-yaml').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        - one
        - two
      YAML
    end
  end

  context 'with a scalar string as top-level data' do
    let(:params) { { 'data' => 'plain string' } }

    it 'renders the string' do
      is_expected.to contain_file('/tmp/test-yaml').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        plain string
      YAML
    end
  end

  context 'with a boolean as top-level data' do
    let(:params) { { 'data' => true } }

    it 'renders the boolean' do
      is_expected.to contain_file('/tmp/test-yaml').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        true
      YAML
    end
  end

  context 'with a numeric scalar as top-level data' do
    let(:params) { { 'data' => 42 } }

    it 'renders the number' do
      is_expected.to contain_file('/tmp/test-yaml').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        42
      YAML
    end
  end

  context 'with sensitive values' do
    it 'renders sensitive values as plain text' do
      is_expected.to contain_file('/tmp/test-yaml-sensitive').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        password: secret
      YAML
    end
  end

  context 'with sort_keys enabled' do
    let(:params) { { 'sort_keys' => true } }

    it 'renders hash keys in sorted order' do
      is_expected.to contain_file('/tmp/test-yaml').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        a:
          c: 3
          d: 4
        b: 2
      YAML
    end
  end

  context 'with sort_keys enabled and an array as top-level data is not sorted' do
    let(:params) { { 'data' => %w[two one], 'sort_keys' => true } }

    it 'preserves array element order' do
      is_expected.to contain_file('/tmp/test-yaml').with_content(<<~YAML)
        ---
        # This file is managed with puppet
        #
        - two
        - one
      YAML
    end
  end
end
