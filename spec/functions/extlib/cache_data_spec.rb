# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::cache_data' do
  let(:initial_data) { 'original_password' }
  let(:data_name) { 'mysql_password' }
  let(:namespace) { 'data_cache' }

  it { expect(subject).not_to eq(nil) }
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params(data_name).and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('', initial_data).and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('', 'mysql_password', initial_data).and_raise_error(ArgumentError) }

  describe 'data caching' do
    context 'when not in cache' do
      it 'returns supplied data' do
        is_expected.to run.with_params(namespace, data_name, initial_data).and_return(initial_data)
      end
    end

    context 'when cached' do
      it 'returns cached data' do
        is_expected.to run.with_params(namespace, data_name, initial_data).and_return(initial_data)
        is_expected.to run.with_params(namespace, data_name, 'new_password').and_return(initial_data)
      end
    end
  end
end
