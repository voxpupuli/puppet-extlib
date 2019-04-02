# Formatting helper for e.g. hosts.allow.
# Takes an ipv6 subnet in CIDR notation and returns a formatted string.
# Especially helpful when having certain network defined in hiera.
#
# example usage
# ```
# ipv6_to_bracket_notation('fe80::f00:b4/120') - returns '[fe80::f00:b4]/120'
# ```
Puppet::Functions.create_function(:'extlib::ipv6_to_bracket_notation') do
  # @param ipv6_with_cidr The ipv6 network in CIDR notation to be formatted
  # return String Returns the formatted string
  dispatch :ipv6_to_bracket_notation do
    param 'Stdlib::IP::Address::V6::CIDR', :ipv6_with_cidr
    return_type 'String'
  end

  def ipv6_to_bracket_notation(ipv6_with_cidr)
    prefix, p_len = ipv6_with_cidr.split('/')
    "[#{prefix}]/#{p_len}"
  end
end
