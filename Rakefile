# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'semver'

def s_version
  SemVer.find.format "%M.%m.%p%s"
end

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'juwelier'
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "elastic-backup-2s3"
  gem.homepage = "http://github.com/flajann2/elastic-backup-2s3"
  gem.license = "MIT"
  gem.version = s_version
  gem.summary = %Q{Elasticsearch to AWS S3 Backup, Snapshotting, and Restore Tool}
  gem.description = %Q{
  I simply want to be able to control the backup and
  restoration of the Elasticsearch cluster to S3
  without any fuss or having to dilly around with
  curl -XPUTS and friends.

  So here it is, and I make no apologies about not 
  supporting the "shared volume" option of Elasticsearch
  snapshots. I may add support at a later date. Or
  feel free to add it and do a pull request.

  There are many features I wish to add to this, and
  if you have any suggestions, please feel free to send
  them my way!}

  gem.email = "fred.mitchell@gmx.de"
  gem.authors = ["Fred Mitchell"]
  gem.required_ruby_version = '>= 2.0'

  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
