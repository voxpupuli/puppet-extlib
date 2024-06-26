# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::ip_to_reverse' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  describe 'IPv4' do
    context 'with an IPv4 address' do
      it { is_expected.to run.with_params('192.0.2.1').and_return('1.2.0.192.in-addr.arpa') }
    end

    context 'with an IPv4 address with CIDR' do
      it { is_expected.to run.with_params('192.0.2.0/24').and_return('0.2.0.192.in-addr.arpa') }
    end
  end

  describe 'IPv6' do
    context 'with an IPv6 address' do
      it { is_expected.to run.with_params('2001:db8::1:1').and_return('1.0.0.0.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa') }
    end

    context 'with an IPv6 address with CIDR' do
      it { is_expected.to run.with_params('2001:db8::2:1/64').and_return('0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa') }
    end
  end
end
