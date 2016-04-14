require 'thor'
require 'semver'
require 'pp'
require 'open3'
require 'colorize'
require 'elasticsearch'
require 'aws-sdk'
require 'multi_json'
require 'faraday'
require 'elasticsearch/api'
require 'awesome_print'
require 'text-table'
require 'active_support/hash_with_indifferent_access'

require_relative 'elastic-backup-2s3/snapshot'

module ElasticBackup
end
