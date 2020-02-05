# All extlib facts are 'namespaced'.  This isn't natively supported by facter, so we do a bit of magic here.
# All fact 'parts' live under a top level `extlib` 'aggregate' fact hash
# The implementation for those parts are separated into files under lib/puppet/extlib

Facter.add(:extlib, type: :aggregate) do
  Dir.glob(File.join(File.dirname(__FILE__), 'extlib/*.rb')).each do |namespaced_fact_file|
    part = File.basename(namespaced_fact_file, '.rb')
    chunk(part.to_sym) do
      require_relative "extlib/#{part}"
      {
        part => Object.const_get("Facter::Extlib::#{part.split('_').map(&:capitalize).join}").value
      }
    end
  end
end

module Facter
  class Extlib; end
end
