# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::array_to_ranges' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params([]).and_return([]) }

  test_cases = {
    [0]                   => %w[0],
    [42]                  => %w[42],
    [1, 2]                => %w[1-2],
    [0, 1, 3]             => %w[0-1 3],
    [0, 2, 3]             => %w[0 2-3],
    [0, 1, 2, 3, 7, 8, 9] => %w[0-3 7-9],
  }.freeze
  test_cases.each do |arg, result|
    it { is_expected.to run.with_params(arg).and_return(result) }
  end
end
