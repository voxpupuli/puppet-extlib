require 'spec_helper'

# rubocop:disable RSpec/MultipleExpectations
describe 'ip_to_cron' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  describe 'when runinterval is 1 hour' do
    let(:runinterval) { 3600 }

    result = nil
    context 'and IP address is 10.0.0.150' do
      let(:facts) { { networking: { ip: '10.0.0.150' } } }

      it 'returns \'*\' for the hour' do
        expect(subject.execute(runinterval)[0]).to eq('*')
      end
      it 'and one value between 0 and 59 for the minute' do
        result = subject.execute(runinterval)
        expect(result[1]).to be_an Array
        expect(result[1].size).to eq(1)
        expect(result[1].first).to be_an Integer
        expect(result[1].first).to be >= 0
        expect(result[1].first).to be < 60
      end
    end
    context 'and IP address is 10.0.0.160' do
      let(:facts) { { networking: { ip: '10.0.0.160' } } }

      it 'returns a different value between 0 and 59 for the minute' do
        result2 = subject.execute(runinterval)
        expect(result2[1].first).to be_an Integer
        expect(result2[1].first).to be >= 0
        expect(result2[1].first).to be < 60
        expect(result2[1].first).not_to eq result[1].first
      end
    end
  end

  describe 'when runinterval is 30 minutes' do
    let(:runinterval) { 1800 }
    let(:facts) { { networking: { ip: '10.0.0.1' } } }

    it 'returns \'*\' for the hour' do
      expect(subject.execute(runinterval)[0]).to eq('*')
    end
    it 'and two \'minute\' values between 0 and 59' do
      minutes = subject.execute(runinterval)[1]
      expect(minutes).to be_an Array
      expect(minutes.size).to eq(2)
      expect(minutes).to all(be_an(Integer))
      expect(minutes).to all(be >= 0)
      expect(minutes).to all(be < 60)
    end
  end

  describe 'when runinterval is 2 hours' do
    let(:runinterval) { 7200 }
    let(:facts) { { networking: { ip: '10.0.0.1' } } }

    it 'returns an array of twelve values between 0..23 for the hour' do
      hours = subject.execute(runinterval)[0]
      expect(hours).to be_an Array
      expect(hours.size).to eq(12)
      expect(hours).to all(be_an(Integer))
      expect(hours).to all(be >= 0)
      expect(hours).to all(be < 24)
    end
  end

  describe 'when runinterval not specified and ip address ends in \'60\'' do
    let(:facts) { { networking: { ip: '10.0.0.60' } } }

    describe 'defaults to every 30 minutes' do
      it { is_expected.to run.and_return(['*', [0, 30]]) }
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
