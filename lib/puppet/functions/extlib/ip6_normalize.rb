# frozen_string_literal: true

require 'ipaddr'

# @summary Normalizes an IPv6 address for comparison
Puppet::Functions.create_function(:'extlib::ip6_normalize') do
  # @param ipv6 The IPv6 address to normalize
  # @return Returns a normalized IPv6 address
  dispatch :ipv6_normalize do
    required_param 'Stdlib::IP::Address::V6', :ipv6
    return_type 'Stdlib::IP::Address::V6'
  end

  def ipv6_normalize(ipv6)
    address, prefix = ipv6.split('/', 2)
    normalized      = IPAddr.new(address).to_s

    prefix ? "#{normalized}/#{prefix}" : normalized
  end
end
