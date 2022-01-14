# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::sort_by_version' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('not_an_array').and_raise_error(ArgumentError) }

  it 'sorts versions' do
    is_expected.to run.
      with_params(['10.0.0b12', '10.0.0b3', '10.0.0a2', '9.0.10', '9.0.3']).
      and_return(['9.0.3', '9.0.10', '10.0.0a2', '10.0.0b3', '10.0.0b12'])
  end
end
