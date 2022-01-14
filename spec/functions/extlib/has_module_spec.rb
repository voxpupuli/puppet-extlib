# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::has_module' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('not_a_valid_module_name').and_raise_error(ArgumentError) }

  context 'modules on our module path' do
    [
      'puppet-extlib',
      'puppet/extlib',
      'puppetlabs/stdlib'
    ].each do |good_module_name|
      it "returns true for #{good_module_name}" do
        is_expected.to run.with_params(good_module_name).and_return(true)
      end
    end
  end

  context 'modules not on our module path' do
    it do
      is_expected.to run.with_params('puppet/nosuchmodule').and_return(false)
    end
  end

  context 'modules not in the right namespace' do
    it do
      is_expected.to run.with_params('puppet/stdlib').and_return(false)
    end
  end
end
