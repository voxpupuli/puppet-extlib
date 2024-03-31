# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::compare_ip' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  it { is_expected.to run.with_params('10.1.1.1', '10.2.1.1').and_return(-1) }
  it { is_expected.to run.with_params('10.2.1.1', '10.2.1.1').and_return(0) }
  it { is_expected.to run.with_params('10.10.1.1', '10.2.1.1').and_return(1) }

  it { is_expected.to run.with_params('fe80::1', 'fe80::2').and_return(-1) }
  it { is_expected.to run.with_params('fe80::2', 'fe80::2').and_return(0) }
  it { is_expected.to run.with_params('fe80::10', 'fe80::2').and_return(1) }

  it { is_expected.to run.with_params('0::ffff:fffe', '255.255.255.255').and_return(-1) }
  it { is_expected.to run.with_params('0::ffff:ffff', '255.255.255.255').and_return(0) }
  it { is_expected.to run.with_params('0::1:0:0', '255.255.255.255').and_return(1) }
end
