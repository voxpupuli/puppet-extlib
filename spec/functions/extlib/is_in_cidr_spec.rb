# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::is_in_cidr' do
  it 'exists' do
    is_expected.not_to eq(nil)
  end

  describe 'IPv4' do
    context 'with an IPv4 address in a IPv4 CIDR' do
      it { is_expected.to run.with_params('192.0.2.1', '192.0.2.0/24').and_return(true) }
    end

    context 'with an IPv4 address outside of a IPv4 CIDR' do
      it { is_expected.to run.with_params('198.51.100.1', '192.0.2.0/24').and_return(false) }
    end
  end

  describe 'IPv6' do
    context 'with an IPv6 address in a IPv6 CIDR' do
      it { is_expected.to run.with_params('1080:0:0:0:8:800:200C:417A', '1080:0::0/64').and_return(true) }
    end

    context 'with an IPv6 address outside of a IPv6 CIDR' do
      it { is_expected.to run.with_params('1080:0:0:0:8:800:200C:417A', '1081:0::0/64').and_return(false) }
    end
  end
end
