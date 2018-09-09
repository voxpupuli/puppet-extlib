require 'spec_helper'

describe 'random_password' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  context 'when called with no parameters' do
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  end

  context 'when called with a string' do
    it { is_expected.to run.with_params('42').and_raise_error(ArgumentError) }
  end

  [4, 32].each do |length|
    context "when called with #{length}" do
      it "returns a string of length #{length}" do
        expect(subject.execute(length)).to be_a String
        subject.execute(length).length == length
      end
    end
  end

  context 'when called multiple times with the same argument' do
    it 'returns different strings' do
      expect(subject.execute(12)).not_to eq(subject.execute(12))
    end
  end
end
