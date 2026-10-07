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

    # `to_s` converts the IPAddr object to the shortened IPv6 notation (e.g., "2001:db8::1")
    # `to_string` converts the IPAddr object to the full IPv6 notation (e.g., "2001:0db8:0000:0000:0000:0000:0000:0001")
    #
    # We explicitly use the shortened notation for normalization here.
    # Please do not change to to_string here!
    normalized      = IPAddr.new(address).to_s

    prefix ? "#{normalized}/#{prefix}" : normalized
  end
end
