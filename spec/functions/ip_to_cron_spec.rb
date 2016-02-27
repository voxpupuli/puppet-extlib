require 'spec_helper'

describe 'ip_to_cron' do
  it { expect(subject).not_to eq(nil) }
  it { is_expected.not_to eq(nil) }

  it 'should return an array of length 2 with runinterval <= 3600' do
    expect(subject.call([3500])).to be_an Array
    expect(subject.call([3500]).length).to eq(2)
  end

  it 'should return an array of length 2 with runinterval > 3600' do
    expect(subject.call([7200])).to be_an Array
    expect(subject.call([7200]).length).to eq(2)
  end
end
