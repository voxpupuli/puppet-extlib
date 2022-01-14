# frozen_string_literal: true

# @summary this function is used to get a list of parameters passed to or resource.
# @example The main two use cases the author envisage for this function are:
#   * Passing Parameters from a profile straight though to a base class
#   We Often aver profiles that pass all, or almost all parameters directly to a base class,
#   this function allows us to more easily pass theses parameters through with out a lot of addtional
#   copy and paste e.g.
#
#       class profile::foobar ($param1, $param2) {
#       class { 'foobar':
#         *                => extlib::dump_params,
#         additional_param => 'foobar',
#       }
#     }
#
#   * Passing parmaters directly to a config file.
#     Another pattern one often sees, are classes where the majority of parameters get passed straight
#     through to some config file.  This function allows us to more easily manage such templating e.g.
#
#     class foobar ($app_param1, $app_param2, $class_param1) {
#       file { '/etc/foo/config.yaml':
#         ensure => file,
#         # class param and name are not understoof by the foo app
#         content => extlib::dump_params(['name', 'class_param1']).to_yaml
#       }
#     }
#
Puppet::Functions.create_function(:'extlib::dump_params', Puppet::Functions::InternalFunction) do
  # @param filter_keys an optional parameters of keys to filter out.  default value is set to 'name'
  dispatch :dump_params do
    scope_param
    optional_param 'Array[String[1]]', :filter_keys
  end

  def dump_params(scope, filter_keys = ['name'])
    scope.resource.to_hash.transform_keys(&:to_s).reject { |k, _v| filter_keys.include?(k) }
  end
end
