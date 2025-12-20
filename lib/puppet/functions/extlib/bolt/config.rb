# frozen_string_literal: true

# Return information about the running Bolt config
Puppet::Functions.create_function(:'extlib::bolt::config') do
  # @return [Any] configuration data
  # @example return the inventory file path
  #   extlib::bolt::config('inventoryfile')
  # @example return puppet module information
  #   extlib::bolt::config('modules')
  dispatch :config do
    param 'String', :key
    return_type 'Any'
  end

  def config(key)
    ObjectSpace.each_object(Bolt::Config).first&.data[key]
  end
end
