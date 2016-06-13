require 'spec_helper'

describe 'cache_data', type: :puppet_function do
  let(:initial_data) { 'original_password' }
  let(:data_name) { 'mysql_password' }
  let(:namespace) { 'data_cache' }
  let(:vardir)    { "#{FIXTURES_PATH}/tmpdir" }

  it { expect(subject).not_to eq(nil) }
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params(data_name).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('', initial_data).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('', 'mysql_password', initial_data).and_raise_error(Puppet::ParseError) }

  describe 'data caching' do
    before do
      # Fool rspec-puppet into creating a consistent vardir for these tests!
      allow(Dir).to receive(:mktmpdir).and_return("#{FIXTURES_PATH}/tmpdir")
      # Stop rspec-puppet from blowing away the vardir between each example.  Is unstubbed in the after block.
      allow(FileUtils).to receive(:rm_rf).with(vardir).and_return(true)
    end
    after do
      # Since rspec-puppet won't be removing the vardir, we'd better do that ourselves.
      File.unstub
      FileUtils.rm_rf(vardir) if File.directory?(vardir)
    end

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
