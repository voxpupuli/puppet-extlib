# frozen_string_literal: true

require_relative '../../../puppet_x/simple_cache'

# @summary Retrieves the latest release tag for a GitHub project
Puppet::Functions.create_function(:'extlib::version_latest_github') do
  # @example Get latest version
  #     extlib::version_latest_github('OpenVoxProject/openvox')
  #     # => 8.23.1
  #
  # @param project The GitHub project to check for releases
  #
  # @return [String] The latest tag for the project
  dispatch :get_latest do
    param 'String[1]', :project
    return_type 'String'
  end

  # @example Get latest version for specified range
  #     extlib::version_latest_github('OpenVoxProject/openvox', '~7')
  #     # => 7.37.2
  #
  # @param project The GitHub project to check for releases
  # @param range The range of acceptable versions
  #
  # @return [String] The latest tag matching the provided range
  dispatch :get_latest_semver do
    param 'String[1]', :project
    param 'SemVerRange', :range
    return_type 'String'
  end

  require 'json'
  require 'net/http'
  require 'uri'

  def base_url
    'https://api.github.com/repos/%s/releases'
  end

  def get_latest(project)
    get_github(project, :latest)['tag_name']
  end

  def get_latest_semver(project, range)
    found = get_github(project).map { |rel| rel['tag_name'] }.find do |version|
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

  def project_slug(project)
    project.tr '/', '_'
  end

  def get_github(project, suffix = nil)
    cache_tag = "gh_#{project_slug(project)}"
    cache_tag += "_#{suffix}" if suffix
    PuppetX::SimpleCache.cache_data(cache_tag) do |meta|
      url = URI([base_url % project, suffix].compact.join('/'))
      hdr = {}
      hdr['if-none-match'] = meta['etag'] if meta['etag']
      resp = Net::HTTP.get_response(url, hdr)
      if resp.is_a? Net::HTTPNotModified
        meta['keep'] = true
      else
        resp.value
        meta['etag'] = resp['etag']
        JSON.parse(resp.body)
      end
    end
  end
end
