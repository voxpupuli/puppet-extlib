require 'spec_helper'

describe 'random_password' do
  it { expect(subject).not_to eq(nil) }
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }

  it 'should return a string of length 4' do
    subject.call([4]).should be_an String
    subject.call([4]).length == 4
  end

  it 'should return a string of length 32' do
    subject.call([32]).should be_an String
    subject.call([32]).length == 32
  end
end
