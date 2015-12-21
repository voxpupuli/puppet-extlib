require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'metadata-json-lint/rake_task'
require 'puppet_blacksmith'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

PuppetLint.configuration.log_format = '%{path}:%{linenumber}:%{check}:%{KIND}:%{message}'
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')

exclude_paths = %w(
  pkg/**/*
  vendor/**/*
  spec/**/*
)
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc 'Run metadata_lint, lint, syntax, and spec tests.'
task test: [
  :metadata_lint,
  :lint,
  :syntax,
  :spec,
]


def blacksmith_freestyle_bump!(new_version)
  m = Blacksmith::Modulefile.new
  path = m.path
  text = File.read(path)
  text = m.replace_version(text, new_version)
  File.open(path, "w") {|file| file.puts text}
  new_version
end

desc 'release new version through Travis-ci'
task "travis_release" do

  require 'puppet_blacksmith/rake_tasks'
  Blacksmith::RakeTask.new do |t|
    t.build = false # do not build the module nor push it to the Forge
    # just do the tagging [:clean, :tag, :bump_commit]
  end

  # always get a fresh version
  v = Blacksmith::Modulefile.new.version.split(/-/)[0]
  # "bump" version to something without the -pre release
  blacksmith_freestyle_bump!(v)

  g = Blacksmith::Git.new

  # check that the changelog contains an entry for the current release
  Rake::Task[:check_changelog].invoke
  # do a "manual" module:release
  Rake::Task["module:clean"].invoke
  # idempotently create tags
  Rake::Task["module:tag"].invoke unless g.exec_git("tag -l v#{v}").strip == "v#{v}"
  Rake::Task["module:bump"].invoke

  puts "Appending pre-release marker -rc0 to version"
  v = Blacksmith::Modulefile.new.version.split(/-/)[0]
  blacksmith_freestyle_bump!("#{v}-rc0")
  # push it out, and let travis do the release:
  g.commit_modulefile!("#{v}-rc0")
  g.push!
end

desc 'Check Changelog.'
task :check_changelog do
  v = Blacksmith::Modulefile.new.version
  if File.readlines('CHANGELOG.md').grep(/Releasing #{v}/).size == 0
    fail "Unable to find a CHANGELOG.md entry for the #{v} release."
  end
end
