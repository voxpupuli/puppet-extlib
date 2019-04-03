# Formatting helper for e.g. hosts.allow.
# Takes an ipv4 subnet in CIDR notation and returns a formatted string.
# Especially helpful when having certain network defined in hiera.
#
# example usage
# ```
# ip_cidr_to_full_mask('1.2.3.4/24') - returns '1.2.3.4/255.255.255.0'
# ```
Puppet::Functions.create_function(:'extlib::ip_cidr_to_full_mask') do
  # @param ip_with_cidr The ipv4 network in CIDR notation to be formatted
  # return String Returns the formatted string
  dispatch :ip_cidr_to_full_mask do
    param 'Stdlib::IP::Address::V4::CIDR', :ip_with_cidr
    return_type 'String'
  end

  require 'ipaddr'
  def ip_cidr_to_full_mask(ip_with_cidr)
    net, cidr = ip_with_cidr.split('/')
    mask = IPAddr.new('255.255.255.255').mask(cidr)
    "#{net}/#{mask}"
  end
end
