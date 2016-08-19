Puppet::Parser::Functions.newfunction(:default_content,
                                      type: :rvalue,
                                      doc: <<-'ENDOFDOC'
Takes an optional content and an optional template name and returns the
contents of a file.

Examples:

    $config_file_content = default_content($file_content, $template_location)
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

  emptyish = ->(x) { return (x.nil? || x.empty? || x == :undef) }

  return content unless emptyish[content]
  return function_template([template_name]) unless emptyish[template_name]

  return :undef
end
