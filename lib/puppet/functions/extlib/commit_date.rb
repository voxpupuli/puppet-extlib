Puppet::Functions.create_function(:'extlib::commit_date', Puppet::Functions::InternalFunction) do
  dispatch :commit_date do
    scope_param
    param 'String', :path
    optional_param 'String', :format
  end

  def commit_date(scope, path, format = nil)
    envdir = File.join(Puppet[:environmentpath], scope.compiler.environment.name.to_s)
    cmd = [
      '/usr/bin/git',
      '--git-dir', File.join(envdir, '.git'),
      '--work-tree', envdir,
      'log', '-1',
      '--pretty=format:%cd',
    ]

    cmd << "--date=format:#{format}" unless format.nil?
    cmd << File.join(envdir, path)

    Puppet::Util::Execution.execute(cmd).to_str
  rescue Puppet::ExecutionFailure => detail
    raise Puppet::Error, "Failed to get commit date for path '#{path}': #{detail}"
  end
end
