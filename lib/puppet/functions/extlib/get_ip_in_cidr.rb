# frozen_string_literal: true

# @summary Retrieves an IP inside of a CIDR based on an index
Puppet::Functions.create_function(:'extlib::get_ip_in_cidr') do
  # @example In 192.168.0.0/24
  #     extlib::get_ip_in_cidr('192.168.0.0/24', 'first')
  #     # => 192.168.0.1
  #     extlib::get_ip_in_cidr('192.168.0.0/24', 'second')
  #     # => 192.168.0.2
  #     extlib::get_ip_in_cidr('192.168.0.0/16', 600)
  #     # => 192.168.1.244
  #     extlib::get_ip_in_cidr('192.168.0.0/16', -2)
  #     # => 192.168.255.254
  #
  # @param cidr The CIDR to work on
  # @param index The index of the IP to retrieve, retrieving from the end if negative
  #
  # @return [String] The requested IP address index in the CIDR
  dispatch :get_ip_in_cidr do
    param 'Variant[Stdlib::IP::Address::V4::CIDR, Stdlib::IP::Address::V6::CIDR]', :cidr
    optional_param 'Variant[Enum["first","second","last"], Integer]', :index
    return_type 'String'
  end

  require 'ipaddr'
  def get_ip_in_cidr(cidr, index = 1)
    cidr = cidr.first if cidr.is_a? Array

    if index.is_a? String
      index = 1 if index == 'first'
      index = 2 if index == 'second'
      index = -1 if index == 'last'
    end

    ip = IPAddr.new(cidr)

    max_width = ip.ipv4? ? 32 : 128
    max_num = 2**(max_width - ip.prefix)

    index = max_num + index if index.negative?
    raise ArgumentError, 'Index is outside of the CIDR' if index >= max_num

    IPAddr.new(ip.to_i + index, ip.family).to_s
  end
end
