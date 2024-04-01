# frozen_string_literal: true

# The `Extlib::CIDR` object represents a CIDR.
#
# @param cidr
# @!method address
# @!method canonical
# @!method netmask
# @!method family
# @!method prefix_length
# @!method first
# @!method last
# @!method host_rewind
# @!method host_next
# @!method host_prev
# @!method host_count
# @!method host_min
# @!method host_max
# @!method to_i
# @!method compare
# @!method include
#
Puppet::DataTypes.create_type('Extlib::CIDR') do
  interface <<-PUPPET
    attributes => {
      cidr => String[1],
      address => { type => String[1], kind => derived },
      canonical => { type => String[1], kind => derived },
      netmask => { type => String[1], kind => derived },
      family => { type => String[1], kind => derived },
      prefix_length => { type => Integer[0], kind => derived },
      is_single_address => { type => Boolean, kind => derived },
      is_link_local => { type => Boolean, kind => derived },
      is_loopback => { type => Boolean, kind => derived },
      is_private => { type => Boolean, kind => derived },
      first => { type => String[1], kind => derived },
      last => { type => String[1], kind => derived },
      count => { type => Integer[0], kind => derived },
      host_count => { type => Integer[0], kind => derived },
      host_min => { type => String[1], kind => derived },
      host_max => { type => String[1], kind => derived },
      host_next => { type => String[1], kind => derived },
      host_prev => { type => String[1], kind => derived },
    },
    functions => {
      host_rewind => Callable[[String[1]], String[1]],
      to_i => Callable[[], Integer[0]],
      compare => Callable[[Variant[Extlib::CIDR, String[1]]], Integer[-1,1]],
      include => Callable[[Variant[Extlib::CIDR, String[1]]], Boolean],
    }
  PUPPET

  load_file('puppet_x/extlib/cidr')

  PuppetX::Extlib::CIDR.include(Puppet::Pops::Types::PuppetObject)
  implementation_class PuppetX::Extlib::CIDR
end
