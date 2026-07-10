# frozen_string_literal: true

# Return information about the running Bolt project
Puppet::Functions.create_function(:'extlib::bolt::project') do
  # @return [Hash] project information
  # @example retrieving the project path
  #   extlib::bolt::project('path')
  dispatch :project do
    param 'String', :key
    return_type 'Any'
  end

  def project(key)
    bolt = ObjectSpace.each_object(Bolt::Project).first

    bolt.instance_variable_get(:"@#{key}")
  end
end
