require 'spec_helper'

describe 'extlib::read_url' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }

  context 'when called with a valid url' do
    it 'returns the content of the url' do
      returned_data = subject.execute('https://raw.githubusercontent.com/voxpupuli/puppet-extlib/master/README.md')
      expect(returned_data).to include('Extlib module for Puppet')
    end
  end
end
