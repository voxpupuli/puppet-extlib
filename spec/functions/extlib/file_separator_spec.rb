# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::file_separator' do
  describe 'windows' do
    let(:facts) do
      {
        kernel: 'windows'
      }
    end

    it { is_expected.to run.with_params.and_return('\\') }
  end

  describe 'not_windows' do
    let(:facts) do
      {
        kernel: 'linux'
      }
    end

    it { is_expected.to run.with_params.and_return('/') }
  end
end
