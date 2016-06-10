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
                   default: ENV['ESB_DEFAULT_REPO'] || 'elastic-backup',
                   desc: "Repository name to use. Use the environment variable ESB_DEFAULT_REPO to change this default."

      class_option :fs, type: :boolean, 
                   desc: "Shared File System Backup. The environment variable ESB_SHARED_VOLUME must be set and also OR you can use the --sharedvol option."

      class_option :nv, type: :boolean, default: false,
                   desc: "Switch off the verify for Shared File System backups and restores. This option is NOT RECOMMENDED, but might be needed in some cases."

      class_option :sharedvol, type: :string, 
                   aliases: '-V',
                   banner: "[ABSOLUTE_PATH_ON_NODES]",
                   default: ENV['ESB_SHARED_VOLUME'] || 'You Must Set Me for --fs Option.',
                   desc: "for the --fs setting, shared volume path that is set up on all the nodes in your cluster. MUST BE SET for FS snapshots. Use the environment variabe ESB_SHARED_VOLUME to avoid setting that here."

      class_option :snapmax, type: :string, 
                   aliases: '-S',
                   banner: "[BYTES_PER_SECOND]",
                   default: ENV['ESB_SNAPSHOT_MAX_BYTES_SEC'] || '500mb',
                   desc: "For the --fs setting, the maximum bytes per second on snaphot creation."

      class_option :remax, type: :string, 
                   aliases: '-R',
                   banner: "[BYTES_PER_SECOND]",
                   default: ENV['ESB_RESTORE_MAX_BYTES_SEC'] || '500mb',
                   desc: "For the --fs setting, the maximum bytes per second on snapshot restoration."

      class_option :monitor, type: :boolean, aliases: '-m', desc: "Monitor the progress.", default: false
      class_option :wait, type: :boolean, aliases: '-w', desc: "Wait for completion.", default: false
      class_option :timeout, type: :numeric,
                   banner: '[SECONDS]',
                   desc: "Explicit operation timeout for connection to master node. Use the environment variable ESB_TIMEOUT to change this default.",
                   aliases: '-t', default: ENV['ESB_TIMEOUT'] || 60

      class_option :indices,  type: :array,   aliases: ['-i', '--indexes'],
                   banner: "[INDEX1[ INDEX2...]|all]",
                   required: false,
                   desc: 'A list of indices to snapshot'

      class_option :dryrun, type: :boolean,
                   aliases: '-u',
                   desc: "Dry run, do not actually execute."

      desc 'snapshot [ES [S3URL|POSTAMBLE]]', 'Backups Elasticsearch indices to S3 or Shared Volume. The POSTAMBLE is appended to the Shared Volume path. Simply make it a "." if none.'
      def snapshot es, s3url
        Snapshot.snapshot Snapshot.esurl(suri: es), s3url, options
      end

      desc 'restore [[S3URL|POSTAMBLE] ES]', 'Restore indices from S3 or Shared Volume to Elasticsearch.  The POSTAMBLE is appended to the Shared Volume path. Simply make it a "." if none.'
      def restore s3url, es
        Snapshot.restore s3url, Snapshot.esurl(suri: es), options
      end
      
      desc 'delete', 'Delete snapshots and repositories'
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
