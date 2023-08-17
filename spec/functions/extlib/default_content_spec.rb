# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::default_content' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params(:undef, :undef).and_return(:undef) }

  describe 'signature validation' do
    it 'exists' do
      is_expected.not_to be_nil
    end
  end

  context 'should return the correct string for' do
    it 'a string' do
      is_expected.to run.with_params('a string', :undef).and_return 'a string'
    end

    it 'an empty string and an epp template' do
      File.write('/tmp/foo.epp', '<% $foo = 2 %>a template string <%= $foo + 1 %>')
      is_expected.to run.with_params(:undef, '/tmp/foo.epp').and_return 'a template string 3'
    end

    it 'an empty string and an erb template' do
      File.write('/tmp/foo.erb', '<% @foo = 1 %>a template string <%= @foo + 1 %>')
      is_expected.to run.with_params(:undef, '/tmp/foo.erb').and_return 'a template string 2'
    end

    it 'an empty string and an empty template' do
      is_expected.to run.with_params(:undef, :undef).and_return :undef
    end
  end
end
