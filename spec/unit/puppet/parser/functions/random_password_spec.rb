require 'spec_helper'

describe 'random_password', type: :puppet_function do
  it { expect(subject).not_to eq(nil) }
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }

  it 'returns a string of length 4' do
    expect(subject.call([4])).to be_a String
    subject.call([4]).length == 4
  end

  it 'returns a string of length 32' do
    expect(subject.call([32])).to be_a String
    subject.call([32]).length == 32
  end
end
