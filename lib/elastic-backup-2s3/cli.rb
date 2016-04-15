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

      class_option :repo, type: :string, 
                   aliases: '-r',
                   banner: "[NAME]",
                   default: 'elastic-backup',
                   desc: "Repository name to use."

      class_option :monitor, type: :boolean, aliases: '-m', desc: "Monitor the progress.", default: false
      class_option :wait, type: :boolean, aliases: '-w', desc: "Wait for completion.", default: false
      class_option :timeout, type: :numeric,
                   banner: '[SECONDS]',
                   desc: "Explicit operation timeout for connection to master node.",
                   aliases: '-t', default: 60

      class_option :indices,  type: :array,   aliases: ['-i', '--indexes'],
                   banner: "[INDEX1[ INDEX2...]|all]",
                   required: false,
                   desc: 'A list of indices to snapshot'

      class_option :dryrun, type: :boolean,
                   aliases: '-u',
                   desc: "Dry run, do not actually execute."

      desc 'snapshot [ES S3URL]', 'Backups Elasticsearch indices to S3'
      def snapshot es, s3url
        Snapshot.snapshot Snapshot.esurl(suri: es), s3url, options
      end

      desc 'restore [S3URL ES]', 'Restore indices from S3 to Elasticsearch.'
      def restore s3url, es
        Snapshot.restore s3url, Snapshot.esurl(es), options
      end
      
      desc 'monitor [ES, SNAPSHOT]', 'Not Implemented Yet -- Monitor the progress of an ongoing snapshot or restore.'
      def monitor 
      end

      desc 'delete', 'Not Implemented Yet -- Delete snapshots, indicies, registrations'
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
