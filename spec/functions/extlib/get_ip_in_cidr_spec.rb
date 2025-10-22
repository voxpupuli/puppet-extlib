# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::get_ip_in_cidr' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('one').and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('192.168.0.0/24', 600).and_raise_error(ArgumentError) }

  it { is_expected.to run.with_params('172.0.0.0/8').and_return('172.0.0.1') }
  it { is_expected.to run.with_params('172.0.0.0/8', 'first').and_return('172.0.0.1') }
  it { is_expected.to run.with_params('172.0.0.0/8', 'second').and_return('172.0.0.2') }
  it { is_expected.to run.with_params('172.0.0.0/8', 'last').and_return('172.255.255.255') }
  it { is_expected.to run.with_params('172.0.0.0/8', -1).and_return('172.255.255.255') }
  it { is_expected.to run.with_params('172.0.0.0/8', 600).and_return('172.0.2.88') }
  it { is_expected.to run.with_params('fe80:dead:beef::/64').and_return('fe80:dead:beef::1') }
  it { is_expected.to run.with_params('fe80:dead:beef::/64', 600).and_return('fe80:dead:beef::258') }
  it { is_expected.to run.with_params('fc00::/7', -42).and_return('fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffd6') }
end
