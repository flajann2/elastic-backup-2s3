# -*- coding: utf-8 -*-
require 'elastic-backup-2s3'
require_relative 'cli/delete'
require_relative 'cli/list'

module ElasticBackup
  module Cli
    class Main < Thor
      long_desc <<-LONGDESC
        Main long desc
      LONGDESC

      class_option :verbose, type: :numeric, 
                   banner: '[1|2|3]',
                   desc: "Verbosity setting.",
                   aliases: '-v', default: 0

      class_option :reg, type: :string, 
                   aliases: '-r',
                   banner: "[NAME]",
                   desc: "Registration name to use."

      class_option :monitor, type: :boolean, aliases: '-m', desc: "Monitor the progress.", default: false

      class_option :indicies,  type: :array,   aliases: ['-i', '--indexes'],
                   banner: "[INDEX1[ INDEX2...]|all]",
                   required: false,
                   desc: 'A list of indices to snapshot'

      class_option :dryrun, type: :boolean,
                   aliases: '-u',
                   desc: "Dry run, do not actually execute."

      desc 'snapshot [ES S3URL]', 'Backups Elasticsearch indices to S3'
      def snapshot(es: 'localhost', surl: nil)
      end

      desc 'restore', 'Restore indices from S3 to Elasticsearch.'
      def restore
      end
      
      desc 'monitor', 'Monitor the progress of an ongoing snapshot or restore.'
      def monitor
      end

      desc 'delete', 'Delete snapshots, indicies, registrations'
      subcommand 'delete', Delete

      desc 'list', 'list indicies, snapshots'
      subcommand 'list', List

      no_commands do
        def massage(options)
          opt = Thor::CoreExt::HashWithIndifferentAccess.new options
          opt[:extra] = Thor::CoreExt::HashWithIndifferentAccess.new opt[:extra].map{ |s| s.split(':', 2)}.to_h
          opt[:tags] = opt[:tags].join(',') unless opt[:tags].nil?
          opt[:sktags] = opt[:sktags].join(',') unless opt[:sktags].nil?
          opt
        end
      end
    end
  end
end
