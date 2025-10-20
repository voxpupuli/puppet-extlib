# frozen_string_literal: true

require_relative '../../../puppet_x/simple_cache'

# @summary Retrieves the latest release name for a product tracked on endoflife.date
Puppet::Functions.create_function(:'extlib::version_latest_endoflife') do
  # @example Get latest version
  #     extlib::version_latest_endoflife('ubuntu')
  #     # => 25.04
  #
  # @param product The endoflife.date product to check for releases
  #
  # @return [String] The latest version for the product
  dispatch :get_latest do
    param 'String[1]', :product
    return_type 'String'
  end

  # @example Get latest version for specified cycle
  #     extlib::version_latest_endoflife('ubuntu', '24.04')
  #     # => 24.04.3
  #
  # @param product The endoflife.date product to check for releases
  # @param cycle The release cycle to check
  #
  # @return [String] The latest version for the product in the provided cycle
  dispatch :get_latest_cycle do
    param 'String[1]', :product
    param 'String[1]', :cycle
    return_type 'String'
  end

  require 'json'
  require 'net/http'
  require 'uri'

  def base_url
    'https://endoflife.date/api/v1'
  end

  def get_latest(product)
    get_latest_cycle(product, :latest)
  end

  def get_latest_cycle(product, cycle)
    data = get_eol(product, cycle)

    # For nicer output
    cycle = cycle == :latest ? nil : " #{cycle}"
    if data['isEol']
      since = " since #{data['eolFrom']}" if data['eolFrom']
      Puppet.warning "Latest version for #{product}#{cycle} is end-of-life#{since}"
    elsif data['isDiscontinued']
      since = " since #{data['discontinuedFrom']}" if data['discontinuedFrom']
      Puppet.warning "Latest version for #{product}#{cycle} is discontinued#{since}"
    end

    data.dig('latest', 'name')
  end

  private

  def get_eol(product, cycle)
    PuppetX::SimpleCache.cache_data("eol_#{product}_#{cycle}") do |meta|
      url = URI([base_url, :products, product, :releases, cycle].join('/'))
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
    end['result']
  end
end
