# frozen_string_literal: true

module PuppetX
  # @summary A simple cache for storing data retrieved from external systems
  module SimpleCache
    # Be a good internet citizen, perform a maximum of 10 queries per day
    DURATION = 2.5 * 60 * 60

    def self.default_cache_path
      File.join(Puppet[:vardir] || '/tmp/puppet', 'simple-cache')
    end

    # @param identifier The cache identifier
    # @param duration How long the cached data should be considered valid - also accepts :forever
    # @param cache_path A custom path to store the cache under
    # @param _block The block to execute in order to retrieve the data requiring caching
    def self.cache_data(identifier, duration: DURATION, cache_path: nil, &_block)
      uid = File.stat(Puppet[:vardir]).uid if Dir.exist?(Puppet[:vardir])
      cache_path ||= default_cache_path

      file = File.join(cache_path, identifier)
      if File.exist?(file)
        begin
          file_data = YAML.safe_load(File.read(file))
          meta = file_data['meta'] || {}
          return file_data['data'] if file_data['data'] && (duration == :forever || Time.at(file_data['at']) + duration > Time.now)
        rescue StandardError # Cache corruption failsafe
          file_data = nil
          meta = {}
        end
      end

      meta ||= {}
      data = yield meta
      data = file_data['data'] if meta.delete('keep') # Never store the keep flag

      raise 'No data to cache' unless data

      FileUtils.mkdir_p(cache_path)
      File.open(file, 'w', 0o600) do |c|
        c.write({ 'data' => data, 'meta' => meta, 'at' => Time.now.to_i }.to_yaml)
      end
      File.chown(uid, nil, file) if uid
      File.chown(uid, nil, cache_path) if uid

      data
    end
  end
end
