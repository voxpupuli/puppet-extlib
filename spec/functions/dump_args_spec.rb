require 'spec_helper'
require 'json'

describe 'dump_args' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  it 'requires an argument' do
    is_expected.to run.with_params.and_raise_error(ArgumentError)
  end

  context 'when called with a hash' do
    let(:hash) { { 'param_one' => 'value', 'param_two' => 42 } }

    it 'puts pretty JSON' do
      allow(STDOUT).to receive(:puts).with(JSON.pretty_generate(hash))
      is_expected.to run.with_params(hash)
    end
  end

  context 'when called with an integer' do
    let(:int) { 42 }

    it 'puts pretty JSON' do
      allow(STDOUT).to receive(:puts).with(JSON.pretty_generate(int))
      is_expected.to run.with_params(int)
    end
  end
end
