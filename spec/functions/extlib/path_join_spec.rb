# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::path_join' do
  describe 'windows' do
    let(:dirs) do
      ['c:', 'tmp', 'test', 'test.txt']
    end

    let(:facts) do
      {
        kernel: 'windows'
      }
    end

    it { is_expected.to run.with_params(dirs).and_return('/c/tmp/test/test.txt') }
    it { is_expected.to run.with_params(['c:\\windows\\puppetlabs\\puppet\\embedded\\gems']).and_return('/c/windows/puppetlabs/puppet/embedded/gems') }
    it { is_expected.to run.with_params(['/c']).and_return('/c') }
  end

  describe 'not_windows' do
    let(:dirs) do
      ['/tmp', 'test', 'test']
    end

    let(:facts) do
      {
        kernel: 'linux'
      }
    end

    it { is_expected.to run.with_params(dirs).and_return('/tmp/test/test') }
    it { is_expected.to run.with_params(['/tmp']).and_return('/tmp') }
  end

  describe 'multiple dirs with comma' do
    let(:dirs) do
      ['/tmp', 'test', 'test']
    end

    let(:facts) do
      {
        kernel: 'linux'
      }
    end

    it { is_expected.to run.with_params(dirs).and_return('/tmp/test/test') }
    it { is_expected.to run.with_params('/tmp', 'test', 'test').and_return('/tmp/test/test') }
  end
end
