# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::ip6_normalize' do
  context 'with params' do
    it 'returns a normalized IPv6 without changes' do
      expect(subject).to run.with_params('2001:db8::123').and_return('2001:db8::123')
    end

    it 'given a IPv6 with all zero segments it returns a normalized IPv6' do
      expect(subject).to run.with_params('2001:db8:0:0:0:0:0:123').and_return('2001:db8::123')
    end

    it 'given a IPv6 with leading zeros it returns a normalized IPv6' do
      expect(subject).to run.with_params('2001:db8::0123').and_return('2001:db8::123')
    end

    it 'given a IPv6 with leading zeros and a prefix it returns a normalized IPv6 with the prefix' do
      expect(subject).to run.with_params('2001:db8::0123/64').and_return('2001:db8::123/64')
    end

    it 'given a IPv6 in capitalized letters it returns a normalized IPv6 in downcase' do
      expect(subject).to run.with_params('2001:DB8::ABCD').and_return('2001:db8::abcd')
    end

    it 'given a loopback address it returns it unchanged' do
      expect(subject).to run.with_params('::1').and_return('::1')
    end

    it 'given an unspecified address it returns it unchanged' do
      expect(subject).to run.with_params('::').and_return('::')
    end

    it 'given an IPv4 address it fails' do
      expect(subject).to run.with_params('10.20.30.40').and_raise_error(%r{'extlib::ip6_normalize' parameter 'ipv6' expects a Stdlib::IP::Address::V6})
    end

    it 'given a malformed IPv6 it fails' do
      expect(subject).to run.with_params('2001:db8:%::0123').and_raise_error(%r{'extlib::ip6_normalize' parameter 'ipv6' expects a Stdlib::IP::Address::V6})
    end
  end
end
