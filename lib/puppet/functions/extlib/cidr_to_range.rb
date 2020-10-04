# Imported by Tim 'bastelfreak' Meusel into voxpupuli/extlib because Yelp/netstdlib got abandoned
#
# @summary Converts an CIDR address of the form 192.168.0.1/24 into a range of IP address excluding the network and broadcast addresses.
#
Puppet::Functions.create_function(:'extlib::cidr_to_range') do
  # @param ip IPv6 or IPv4 address in CIDR notation
  # @return IPv6 or IPv4 ip range without net/broadcast
  # @example calling the function
  #   extlib::cidr_to_range('127.0.0.1/8')
  dispatch :cidr_to_range do
    param 'Variant[Stdlib::IP::Address::V4::CIDR,Stdlib::IP::Address::V6::CIDR]', :ip
    return_type 'Variant[Array[Stdlib::IP::Address::V4::Nosubnet],Array[Stdlib::IP::Address::V6::Nosubnet]]'
  end

  def cidr_to_range(ip)
    ips = IPAddr.new(ip).to_range.map(&:to_s)
    ips.shift
    ips.pop
    ips
  end
end
