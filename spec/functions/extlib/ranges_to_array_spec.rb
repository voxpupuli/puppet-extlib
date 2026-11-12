# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::ranges_to_array' do
  it { is_expected.not_to be_nil }

  good_test_cases = {
    %w[0]         => [0],
    '0'           => [0],
    %w[42]        => [42],
    '42'          => [42],
    %w[1-2]       => [1, 2],
    '1-2'         => [1, 2],
    %w[0-1 3]     => [0, 1, 3],
    '0-1,3'       => [0, 1, 3],
    %w[0 2-3]     => [0, 2, 3],
    ' 0 , 2-3 '   => [0, 2, 3],
    %w[0-3 7-9]   => [0, 1, 2, 3, 7, 8, 9],
    '0-3, 7-9'    => [0, 1, 2, 3, 7, 8, 9],
    '0-6,5-9,1-2' => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  }.freeze
  good_test_cases.each do |arg, result|
    it { is_expected.to run.with_params(arg).and_return(result) }
  end

  bad_test_cases = [
    '0xa',
    'a',
    '1-',
    '-5',
    '5-3',
    '1,,2',
    '1-2-3',
  ].freeze
  bad_test_cases.each do |arg|
    it { is_expected.to run.with_params(arg).and_raise_error(%r{invalid range}) }
  end
end
