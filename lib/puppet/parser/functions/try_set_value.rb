module Puppet::Parser::Functions
  newfunction(
      :try_set_value,
      :arity => -3,
      :doc => <<-eos
Set a deep structure value inside a hash or an array.

$data = {
  'a' => {
    'b' => [
      'b1',
      'b2',
      'b3',
    ]
  }
}

try_set_value($data, 'a/b/2', 'new_value', '/')

=> $data = {
  'a' => {
    'b' => [
      'b1',
      'b2',
      'new_value',
    ]
  }
}

a -> first hash key
b -> second hash key
2 -> array index starting with 0

new_value -> new value to be assigned
/ -> (optional) path delimiter. Defaults to '/'
  eos
  ) do |args|

    path_set = lambda do |data, path, value|
      if data.nil?
        debug 'Try_set_value: no data, return false'
        break false
      end
      unless path.is_a? Array
        debug 'Try_set_value: wrong path, return false'
        break false
      end
      unless path.any?
        debug 'Try_set_value: empty path, return false'
        break false
      end
      unless data.is_a? Hash or data.is_a? Array
        debug 'Try_set_value: non-empty path and non-structure data, return false'
        break false
      end

      key = path.shift

      if data.is_a? Array
        begin
          key = Integer key
        rescue ArgumentError
          debug 'Try_set_value: non-numeric path for an array, return false'
          break false
        end
      end

      if path.empty?
        data[key] = value
        debug "Try_set_value: setting structure: '#{data.inspect}' key/index: '#{key}' to: '#{value.inspect}', return true"
        break true
      end

      path_set.call data[key], path, value
    end

    data = args[0]
    path = args[1] || ''
    value = args[2]
    separator = args[3] || '/'

    path = path.split separator
    path_set.call data, path, value
  end
end
