# -*- coding: utf-8 -*-
module ElasticBackup
  module Cli
    class Delete < Thor
      desc 'snapshot [ES S3URL|POSTAMBLE]', 'Delete a snapshot or kill one in progress.'
      long_desc S3POSTDOCS
      
      option :repo, type: :string, 
                   aliases: '-r',
                   banner: "[NAME]",
                   default: 'elastic-backup',
                   desc: "Repository name to use."
      def snapshot es, s3url
        esurl = Snapshot.esurl suri: es
        puts "deleting snapshot at #{esurl}" unless options[:verbose] < 1
        cli = Snapshot.elastic esurl
        _bucket_name, _path, snapshot = Snapshot.s3url_splice s3url
        result = MultiJson.load cli.snapshot.delete(repository: options[:repo],
                                                    snapshot: snapshot)
        ap result unless options[:verbose] < 1
         if result['status'] == 404
           puts "Snapshot #{snapshot} does not exist."
           exit 1
         end
      end

    end
  end
end
