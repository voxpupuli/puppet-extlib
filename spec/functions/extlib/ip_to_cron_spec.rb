require 'spec_helper'

describe 'extlib::ip_to_cron' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  describe 'when runinterval is 1 hour' do
    let(:runinterval) { 3600 }

    context 'and IP address is 10.0.0.150' do
      let(:facts) { { networking: { ip: '10.0.0.150' } } }

      it { is_expected.to run.with_params(runinterval).and_return(['*', [30]]) }
    end

    context 'and IP address is 10.0.0.160' do
      let(:facts) { { networking: { ip: '10.0.0.160' } } }

      it { is_expected.to run.with_params(runinterval).and_return(['*', [40]]) }
    end
  end

  context 'with IP address 10.0.0.1' do
    let(:facts) { { networking: { ip: '10.0.0.1' } } }

    describe 'when runinterval is 30 minutes' do
      let(:runinterval) { 1800 }

      it { is_expected.to run.with_params(runinterval).and_return(['*', [1, 31]]) }
    end

    describe 'when runinterval is 2 hours' do
      let(:runinterval) { 7200 }

      it { is_expected.to run.with_params(runinterval).and_return([[1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23], 1]) }
    end
  end

  describe 'when runinterval not specified and IP address is 10.0.0.60' do
    let(:facts) { { networking: { ip: '10.0.0.60' } } }

    it { is_expected.to run.and_return(['*', [0, 30]]) }
  end
end
