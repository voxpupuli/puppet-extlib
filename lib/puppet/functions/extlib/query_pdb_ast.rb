# frozen_string_literal: true

# @summary Execute raw PuppetDB AST queries with optional error handling
#
# Sends a PuppetDB AST (Abstract Syntax Tree) query directly to PuppetDB and
# returns the unprocessed result. Supports optional graceful error handling
# via the `default` parameter.
#
# This function is intentionally unopinionated: it executes your query and
# returns whatever PuppetDB returns. Query construction is your responsibility.
#
# Unlike the native puppetdb_query, you may provide an optional rescue value.
#
# == Query Syntax (PuppetDB 4.0+ AST)
#
# PuppetDB 4.0+ AST queries must use the `from` operator as context, followed
# by optional filter clauses:
#
#   ["from", "entity_name", [filter1], [filter2], ...]
#
# Common comparison operators:
#
# - ["=", field, value]       - Equality
# - ["!=", field, value]      - Inequality
# - [">", field, value]       - Greater than
# - ["<", field, value]       - Less than
# - [">=", field, value]      - Greater than or equal
# - ["<=", field, value]      - Less than or equal
# - ["~", field, regex]       - Regex match
# - ["~>", path, pattern]     - Regex match on path arrays
# - ["null?", field, bool]    - Field is null/not null
#
# Boolean operators:
#
# - ["and", clause, clause, ...]  - All clauses must match
# - ["or", clause, clause, ...]   - Any clause must match
# - ["not", clause]               - Clause must not match
#
# Subqueries (implicit):
#
# - ["subquery", "entity", clause]  - Correlate data from related entity
#
# For complete operator reference (extract, group_by, limit, offset, etc.):
# https://www.puppet.com/docs/puppetdb/latest/api/query/v4/ast.html
#
# == Error Handling
#
# Without `default`: Query failures raise an error and halt compilation.
# With `default`: Query failures return the default value instead.
#
# You can safely use `default => undef` to make a query optional:
#   $data = extlib::query_pdb_ast(['from', 'nodes'], default => undef)
#   if $data { ... }
#
# @example Query all nodes
#   $all_nodes = extlib::query_pdb_ast(['from', 'nodes'])
#
# @example With graceful fallback to empty array
#   $nodes = extlib::query_pdb_ast(['from', 'nodes'], default => [])
#
# @example Find resources by type
#   $packages = extlib::query_pdb_ast([
#     'from', 'resources',
#     ['=', 'type', 'Package']
#   ])
#
# @example Query facts with conditions
#   $rhel_nodes = extlib::query_pdb_ast([
#     'from', 'facts',
#     ['and',
#       ['=', 'name', 'os.family'],
#       ['=', 'value', 'RedHat']
#     ]
#   ])
#
# @example Class-based peer discovery with paging
#   $elk_nodes = extlib::query_pdb_ast(
#     ['from', 'resources',
#       ['and',
#         ['=', 'type', 'Class'],
#         ['=', 'title', 'Elasticsearch'],
#         ['=', 'environment', $server_facts['environment']]
#       ],
#       ['order_by', [['certname', 'asc']]],
#       ['limit', 100]
#     ],
#     default => []
#   ).map |$r| { $r['certname'] }.unique
#
# @example Optional query with subquery (graceful when PuppetDB down)
#   $reports = extlib::query_pdb_ast(
#     ['from', 'reports',
#       ['=', 'environment', 'production'],
#       ['limit', 10]
#     ],
#     default => undef
#   )
#   if $reports {
#     notice("Found ${reports.length} reports")
#   }
#
# @param query [Array] PuppetDB 4.0+ AST query as an array. Must use the `from`
#   operator: ["from", entity_name, filter_clause, ...]. Consult PuppetDB
#   documentation for valid syntax and operators.
#
# @param default [Any] Optional value to return if the query fails. If not
#   provided, query failures raise an error. Pass `undef` to make queries optional.
#
# @return [Any] The unprocessed result from PuppetDB (typically Array or Hash),
#   or the `default` value if query fails and default was provided.
#
# @raise Raises PuppetDB errors as-is if query fails and no `default` provided.
#   This includes connection errors, query syntax errors, and timeout errors.
#
Puppet::Functions.create_function(:'extlib::query_pdb_ast') do
  dispatch :query_pdb_ast do
    param 'Array', :query
    optional_param 'Any', :default
    return_type 'Any'
  end

  def query_pdb_ast(query, default = :__no_default_set__)
    call_function('puppetdb_query', query)
  rescue StandardError => e
    raise e if default == :__no_default_set__

    default
  end
end
