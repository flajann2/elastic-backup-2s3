# Generated by juwelier
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Juwelier::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: elastic-backup-2s3 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "elastic-backup-2s3"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Fred Mitchell"]
  s.date = "2016-04-22"
  s.description = "\n  I simply want to be able to control the backup and\n  restoration of the Elasticsearch cluster to S3\n  without any fuss or having to dilly around with\n  curl -XPUTS and friends.\n\n  So here it is, and I make no apologies about not \n  supporting the \"shared volume\" option of Elasticsearch\n  snapshots. I may add support at a later date. Or\n  feel free to add it and do a pull request.\n\n  There are many features I wish to add to this, and\n  if you have any suggestions, please feel free to send\n  them my way!"
  s.email = "fred.mitchell@gmx.de"
  s.executables = ["es-snapshot"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.org"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".ruby-version",
    ".semver",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.org",
    "Rakefile",
    "bin/es-snapshot",
    "elastic-backup-2s3.gemspec",
    "lib/elastic-backup-2s3.rb",
    "lib/elastic-backup-2s3/cli.rb",
    "lib/elastic-backup-2s3/cli/delete.rb",
    "lib/elastic-backup-2s3/cli/list.rb",
    "lib/elastic-backup-2s3/snapshot.rb",
    "spec/elastic-backup-2s3_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/flajann2/elastic-backup-2s3"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0")
  s.rubygems_version = "2.5.1"
  s.summary = "Elasticsearch to AWS S3 Backup, Snapshotting, and Restore Tool"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<semver>, ["~> 1"])
      s.add_runtime_dependency(%q<aws-sdk>, ["~> 2"])
      s.add_runtime_dependency(%q<elasticsearch>, ["~> 1"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1"])
      s.add_runtime_dependency(%q<faraday>, ["~> 0"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 4"])
      s.add_runtime_dependency(%q<awesome_print>, ["~> 1"])
      s.add_runtime_dependency(%q<text-table>, ["~> 1"])
      s.add_runtime_dependency(%q<thor>, ["~> 0"])
      s.add_runtime_dependency(%q<colorize>, ["~> 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2"])
      s.add_development_dependency(%q<yard>, ["~> 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3"])
      s.add_development_dependency(%q<bundler>, ["~> 1"])
      s.add_development_dependency(%q<juwelier>, ["~> 2"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<pry>, ["~> 0"])
      s.add_development_dependency(%q<pry-byebug>, ["~> 3"])
      s.add_development_dependency(%q<pry-doc>, ["~> 0"])
      s.add_development_dependency(%q<pry-remote>, ["~> 0"])
      s.add_development_dependency(%q<pry-rescue>, ["~> 1"])
      s.add_development_dependency(%q<pry-stack_explorer>, ["~> 0"])
    else
      s.add_dependency(%q<semver>, ["~> 1"])
      s.add_dependency(%q<aws-sdk>, ["~> 2"])
      s.add_dependency(%q<elasticsearch>, ["~> 1"])
      s.add_dependency(%q<multi_json>, ["~> 1"])
      s.add_dependency(%q<faraday>, ["~> 0"])
      s.add_dependency(%q<activesupport>, ["~> 4"])
      s.add_dependency(%q<awesome_print>, ["~> 1"])
      s.add_dependency(%q<text-table>, ["~> 1"])
      s.add_dependency(%q<thor>, ["~> 0"])
      s.add_dependency(%q<colorize>, ["~> 0"])
      s.add_dependency(%q<rspec>, ["~> 2"])
      s.add_dependency(%q<yard>, ["~> 0"])
      s.add_dependency(%q<rdoc>, ["~> 3"])
      s.add_dependency(%q<bundler>, ["~> 1"])
      s.add_dependency(%q<juwelier>, ["~> 2"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<pry>, ["~> 0"])
      s.add_dependency(%q<pry-byebug>, ["~> 3"])
      s.add_dependency(%q<pry-doc>, ["~> 0"])
      s.add_dependency(%q<pry-remote>, ["~> 0"])
      s.add_dependency(%q<pry-rescue>, ["~> 1"])
      s.add_dependency(%q<pry-stack_explorer>, ["~> 0"])
    end
  else
    s.add_dependency(%q<semver>, ["~> 1"])
    s.add_dependency(%q<aws-sdk>, ["~> 2"])
    s.add_dependency(%q<elasticsearch>, ["~> 1"])
    s.add_dependency(%q<multi_json>, ["~> 1"])
    s.add_dependency(%q<faraday>, ["~> 0"])
    s.add_dependency(%q<activesupport>, ["~> 4"])
    s.add_dependency(%q<awesome_print>, ["~> 1"])
    s.add_dependency(%q<text-table>, ["~> 1"])
    s.add_dependency(%q<thor>, ["~> 0"])
    s.add_dependency(%q<colorize>, ["~> 0"])
    s.add_dependency(%q<rspec>, ["~> 2"])
    s.add_dependency(%q<yard>, ["~> 0"])
    s.add_dependency(%q<rdoc>, ["~> 3"])
    s.add_dependency(%q<bundler>, ["~> 1"])
    s.add_dependency(%q<juwelier>, ["~> 2"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<pry>, ["~> 0"])
    s.add_dependency(%q<pry-byebug>, ["~> 3"])
    s.add_dependency(%q<pry-doc>, ["~> 0"])
    s.add_dependency(%q<pry-remote>, ["~> 0"])
    s.add_dependency(%q<pry-rescue>, ["~> 1"])
    s.add_dependency(%q<pry-stack_explorer>, ["~> 0"])
  end
end

