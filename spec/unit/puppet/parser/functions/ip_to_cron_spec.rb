require 'spec_helper'

# rubocop:disable RSpec/MultipleExpectations
describe 'ip_to_cron', type: :puppet_function do
  it 'exists' do
    expect(Puppet::Parser::Functions.function('ip_to_cron')).to eq('function_ip_to_cron')
  end

  describe 'when runinterval is 1 hour' do
    let(:runinterval) { 3600 }
    result = nil
    context 'and IP address is 10.0.0.150' do
      before do
        allow(scope).to receive(:lookupvar).with('ipaddress').and_return('10.0.0.150')
      end
      it 'returns \'*\' for the hour' do
        expect(subject.call([runinterval])[0]).to eq('*')
      end
      it 'and one value between 0 and 59 for the minute' do
        result = subject.call([runinterval])
        expect(result[1]).to be_an Array
        expect(result[1].size).to eq(1)
        expect(result[1].first).to be_an Integer
        expect(result[1].first).to be >= 0
        expect(result[1].first).to be < 60
      end
    end
    context 'and IP address is 10.0.0.160' do
      before do
        allow(scope).to receive(:lookupvar).with('ipaddress').and_return('10.0.0.160')
      end
      it 'returns a different value between 0 and 59 for the minute' do
        result2 = subject.call([runinterval])
        expect(result2[1].first).to be_an Integer
        expect(result2[1].first).to be >= 0
        expect(result2[1].first).to be < 60
        expect(result2[1].first).not_to eq result[1].first
      end
    end
  end

  describe 'when runinterval is 30 minutes' do
    let(:runinterval) { 1800 }
    before do
      allow(scope).to receive(:lookupvar).with('ipaddress').and_return('10.0.0.1')
    end
    it 'returns \'*\' for the hour' do
      expect(subject.call([runinterval])[0]).to eq('*')
    end
    it 'and two \'minute\' values between 0 and 59' do
      minutes = subject.call([runinterval])[1]
      expect(minutes).to be_an Array
      expect(minutes.size).to eq(2)
      minutes.each do |minute|
        expect(minute).to be_an Integer
        expect(minute).to be >= 0
        expect(minute).to be < 60
      end
    end
  end

  describe 'when runinterval is 2 hours' do
    let(:runinterval) { 7200 }
    before do
      allow(scope).to receive(:lookupvar).with('ipaddress').and_return('10.0.0.1')
    end
    it 'returns an array of twelve values between 0..23 for the hour' do
      hours = subject.call([runinterval])[0]
      expect(hours).to be_an Array
      expect(hours.size).to eq(12)
      hours.each do |hour|
        expect(hour).to be_an Integer
        expect(hour).to be >= 0
        expect(hour).to be < 24
      end
    end
  end

  describe 'when runinterval not specified and ip address ends in \'60\'' do
    before do
      allow(scope).to receive(:lookupvar).with('ipaddress').and_return('10.0.0.60')
    end
    describe 'defaults to every 30 minutes' do
      it { is_expected.to run.with_params.and_return(['*', [0, 30]]) }
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
