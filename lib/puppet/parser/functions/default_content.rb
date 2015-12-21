module Puppet::Parser::Functions
  Puppet::Parser::Functions.newfunction(:default_content,
                                        :type => :rvalue,
                                        :doc => <<-'ENDOFDOC'
  Takes an optional content and an optional template name and returns the
  contents of a file.

  Examples:

      $config_file_content = default_content($config_file_string, $config_file_template)
      file { '/tmp/x':
        ensure  => 'file',
        content => $config_file_content,
      }
  ENDOFDOC
  ) do |args|
    content = args[0]
    template_name = args[1]

    # Load template function from puppet
    Puppet::Parser::Functions.function('template')

    return content if content != ''
    return function_template([template_name]) if template_name

    return nil
  end
end
