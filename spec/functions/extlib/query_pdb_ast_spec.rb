# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::query_pdb_ast' do
  # Type validation tests
  context 'with type validation' do
    it 'requires query parameter to be an array' do
      is_expected.to run.with_params('not-an-array').and_raise_error(ArgumentError)
    end

    it 'requires query parameter to be an array (hash fails)' do
      is_expected.to run.with_params({ 'foo' => 'bar' }).and_raise_error(ArgumentError)
    end

    it 'requires query parameter to be an array (nil fails)' do
      is_expected.to run.with_params(nil).and_raise_error(ArgumentError)
    end

    it 'requires query parameter to be an array (integer fails)' do
      is_expected.to run.with_params(123).and_raise_error(ArgumentError)
    end
  end

  # Basic function definition checks
  it { is_expected.not_to be_nil }
end
