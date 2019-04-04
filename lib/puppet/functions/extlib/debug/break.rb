begin
  require 'puppet-debugger'
rescue LoadError => e
  Puppet.err('You must install the puppet-debugger: gem install puppet-debugger')
end

# @summary Injects a puppet debugger session where the break point was placed.
#
# This function allows you to set a breakpoint and break into the puppet compiler
# allowing you to interact with the puppet manifest.  Think of this like a 
# interactive manifest where the scope, facts and code is setup for you to play
# with in real time. This function is similar to binding.pry for ruby but instead
# is use solely  with the puppet debugger which is just for puppet code only.
#
# ```ruby
# Ruby Version: 2.5.1
# Puppet Version: 6.4.0
# Puppet Debugger Version: 0.10.3
# Created by: NWOps <corey@nwops.io>
# Type "commands" for a list of debugger commands
# or "help" to show the help screen.
#
#         8:   service{'httpd': ensure => running}
#         9:    $var2 = ['value1', 'value2'] 
#         10:   # how to find values with an empheral scope
#         11:   $var2.each | String $item | {
#         12:     file{"/tmp/${item}": ensure => present}
#      => 13:     extlib::debug::break()
#         14:   }
#         15:   extlib::debug::break()
#         16:   if $var1 == 'value1' {
#         17:     extlib::debug::break()
#         18:   }
# 1:>> $item
# => "value1"
# ````
#
# @example How to find values with an empheral scope.
#  $var2.each | String $item | {
#    file{"/tmp/${item}": ensure => present}
#    extlib::debug::break()
#  }
#
# @example - Insert a breakpoint anywhere in your puppet code.
#   extlib::debug::break()
#
#
Puppet::Functions.create_function(:'extlib::debug::break', Puppet::Functions::InternalFunction) do
  # the function below is called by puppet and and must match
  # the name of the puppet function above.

  # The debugger_stack_count is used to determine if this function has already been called
  # in order to prevent additionally help output from the debugger 

  def initialize(scope, loader)
    super
    @debugger_stack_count = 0
  end

  # @return [Integer] - returns the nunber of debugger instances currently alive
  # @param options [Hash] - a hash of puppet debugger options, not required
  dispatch :break do
    scope_param
    optional_param 'Hash', :options
  end

  def break(scope, options = {})
    if $stdout.isatty
      options = options.merge({:scope => scope})
      # forking the process allows us to start a new debugger shell
      # for each occurrence of the start_debugger function
      pid = fork do
        # required in order to use convert puppet hash into ruby hash with symbols
        options = options.inject({}){|data,(k,v)| data[k.to_sym] = v; data}
        options[:source_file], options[:source_line] = stacktrace.last
        # suppress future debugger help screens
        @debugger_stack_count = @debugger_stack_count + 1
        # suppress future debugger help screens since we probably started from the debugger, so look for this string
        # in the filename to detect
        @debugger_stack_count = @debugger_stack_count + 1 if options[:source_file] =~ /puppet_debugger_input/
        options[:quiet] = true if @debugger_stack_count > 1
        ::PuppetDebugger::Cli.start_without_stdin(options)
      end
      Process.wait(pid)
      @debugger_stack_count = @debugger_stack_count + 1
    else
      Puppet.warning 'debug::breakpoint(): refusing to start the debugger on a daemonized master'
    end
  end

  # returns a stacktrace of called puppet code
  # @return [String] - file path to source code
  # @return [Integer] - line number of called function
  # This method originally came from the puppet 4.6 codebase and was backported here
  # for compatibility with older puppet versions
  # The basics behind this are to find the `.pp` file in the list of loaded code
  def stacktrace
    result = caller().reduce([]) do |memo, loc|
      if loc =~ /\A(.*\.pp)?:([0-9]+):in\s(.*)/
        # if the file is not found we set to code
        # and read from Puppet[:code]
        # $3 is reserved for the stacktrace type
        memo << [$1.nil? ? :code : $1, $2.to_i]
      end
      memo
    end.reverse
  end
end
