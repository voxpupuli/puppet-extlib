# frozen_string_literal: true

require_relative '../../../puppet_x/simple_cache'

# @summary Retrieves the latest version for a project on Anitya / release-monitoring.org
Puppet::Functions.create_function(:'extlib::version_latest_anitya') do
  # @example Get latest version
  #     extlib::version_latest_anitya(4223) # Project 4223 is Ruby
  #     # => 3.4.6
  #
  # @param project The Anitya project to check for releases
  #
  # @return [String] The latest version for the project
  dispatch :get_latest do
    param 'Integer[1]', :project
    return_type 'String'
  end

  # @example Get latest version for a specified range
  #     extlib::version_latest_anitya(4223, '~3.3') # Project 4223 is Ruby
  #     # => 3.3.9
  #
  # @param project The Anitya project to check for releases
  # @param range The range of acceptable versions
  #
  # @todo Allow retrieving pre-release versions
  #
  # @return [String] The latest tag matching the provided range
  dispatch :get_latest_semver do
    param 'Integer[1]', :project
    param 'SemVerRange', :range
    return_type 'String'
  end

  require 'json'
  require 'net/http'
  require 'uri'

  def base_url
    'https://release-monitoring.org/api/v2/'
  end

  def get_latest(project)
    get_anitya(project)['latest_version']
  end

  def get_latest_semver(project, range)
    found = get_anitya(project)['stable_versions'].find do |version|
      version = version[1..] if version[0].downcase == 'v'
      if version.count('.') < 2
        # Handle semver-like version numbers (e.g. Version 2, Version 1.5, Version 0.4)
        parts = version.split '.'
        parts.map! { |part| part =~ %r{^\d+$} ? part.to_i : part }
        parts << 0 until parts.size >= 3
        version = parts.join '.'
      end

      version = SemanticPuppet::Version.parse(version)
      range.include? version
    rescue SemanticPuppet::Version::ValidationFailure
      # Invalid version number in list, continue
    end

    raise "No stable versions found that matches #{range}" unless found

    found
  end

  private

  def get_anitya(project)
    PuppetX::SimpleCache.cache_data("anitya_#{project}") do
      url = URI([base_url, 'versions/?project_id=', project].join)
      resp = Net::HTTP.get_response(url)
      resp.value
      JSON.parse(resp.body)
    end
  end
end
