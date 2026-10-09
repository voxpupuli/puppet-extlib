# @summary Takes a hash of argument names and values and returns a command-line string
# @example
#  extlib::argparse({hostname => 'foo.example.org', port => 8080, ssl => true}) =>
#   '--hostname foo.example.org --port 8080 --ssl'
# @param args the arguments to parse
# @param prefix the prefix to put at the start of the command e.g. /usr/bin/binary
# @param separator use to separator argument switches from the value
# @param array_join the string to use to join array elements
# @param arg_prefix the prefix to put before each argument switch, e.g. '-', '--', or undef to auto-detect based on the argument name length
#
function extlib::argparse (
  Hash[String[1], Variant[Boolean, String, Numeric, Array[Variant[String, Numeric]]]] $args,
  String                                                                              $prefix     = '',
  String[1, 1]                                                                        $separator  = ' ',
  String[1, 1]                                                                        $array_join = ',',
  Optional[String[1, 2]]                                                              $arg_prefix = undef,
) >> String {
  $args.reduce($prefix) |$memo, $value| {
    $_arg_prefix = $arg_prefix ? {
      undef   => ($value[0].size == 1).bool2str('-', '--'),
      default => $arg_prefix,
    }
    $args_str = $value[1] ? {
      Boolean => $value[1].bool2str("${_arg_prefix}${value[0]}", ''),
      Array   => "${_arg_prefix}${value[0]}${separator}${value[1].join($array_join).shell_escape}",
      # handle spaces, double quotes, etc.
      default => "${_arg_prefix}${value[0]}${separator}${value[1].shell_escape}",
    }
    if $args_str.empty() {
      $memo
    } elsif $memo.empty() {
      $args_str
    } else {
      "${memo} ${args_str}"
    }
  }
}
