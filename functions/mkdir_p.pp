# @summary Like the unix command mkdir_p except with puppet code.
# This creates file resources for all directories and utilizes the dir_split() function
# to get a list of all the descendant directories.  You will have no control over any other parameters
# for the file resource.  If you wish to control the file resources you can use the dir_split() function
# and get an array of directories for use in your own code.  Please note this does not use an exec resource.
#
# @param dirs [Variant[Stdlib::Absolutepath, Array[Stdlib::Absolutepath]]] - the path(s) to create
# @return [Array[Stdlib::Absolutepath]]
# @example How to use
#  extlib::mkdir_p('/opt/puppetlabs/bin') => ['/opt', '/opt/puppetlabs', '/opt/puppetlabs/bin']
# @note splits the given directories into paths that are then created using file resources
# @note if you wish to create the directories manually you can use the extlib::dir_split() function in the same manner
function extlib::mkdir_p(
  Variant[Stdlib::Absolutepath, Array[Stdlib::Absolutepath]] $dirs,
  Hash                                                       $parms = {},
) >> Array[Stdlib::Absolutepath] {
  $all_dirs = extlib::dir_split($dirs)
  # ensure all parent directories exist
  ensure_resource('file', $all_dirs, {'ensure' => 'directory'})
  [$dirs].flatten.unique.each |$dir| {
    File[$dir] {
      * => $params,
    }
  }
  $all_dirs
}
