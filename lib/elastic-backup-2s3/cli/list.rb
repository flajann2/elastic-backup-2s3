# -*- coding: utf-8 -*-
module ElasticBackup
  module Cli
    class List < Thor

      desc 'indices [ES]', 'List indicies in Elasticsearch'
      option :detailed, type: :boolean, aliases: '-d', desc: "Give full detailed dump of the indices.", default: false
      def indices es = "localhost"
        esurl = Snapshot.esurl suri: es
        puts "query #{esurl}" unless options[:verbose] < 1
        cli = Snapshot.elastic esurl
        indices = MultiJson.load cli.cat.indices

        unless options[:detailed]
          table = Text::Table.new
          table.head = ['Index',
                        'Status',
                        'Health',
                        'Docs',
                        'Size']
          table.rows = indices.map { |idx|
            [idx["index"],
             idx["status"],
             idx["health"],
             idx["docs.count"],
             idx["store.size"]]
          }
          puts table
        else
          ap indices
        end
      end

      desc 'snaphots [S3URL]', 'List all snapshots or clusters stored at S3URL. A cluster is assumed to be a collection of clusters within the S3URL, each containing one or more snapshots.'
      #option :detailed, type: :boolean, aliases: '-d', desc: "Give full detailed dump of the snapshots.", default: false
      #option :clusters, type: :boolean, aliases: '-c', desc: "List clusters instead of snapshots. NOT SUPPORTED YET", default: false
      def snapshots surl
        bucket_name, path, snapshot = Snapshot.s3url_splice surl
        puts "from bucket #{bucket_name}, path #{path}" unless options[:verbose] < 1
        bucket = Snapshot.s3.bucket bucket_name
        raise "bucket #{bucket_name} does not exist" unless bucket.exists?
        ap bucket.objects(prefix: "#{path}/snapshot").map { |ob|
          ob.key.split('snapshot-').last
        }
      end

      desc 'status [ES]', 'List the status of the snapshots on the given ES cluster.'
      option :detailed, type: :boolean, aliases: '-d', desc: "Give full detailed dump of the status.", default: false
      def status es = "localhost"
        esurl = Snapshot.esurl suri: es
        puts "query #{esurl}" unless options[:verbose] < 1
        cli = Snapshot.elastic esurl
        statuses = MultiJson.load cli.snapshot.get(repository: options[:repo],
                                                   snapshot: '_all')
        raise statuses['error'] unless statuses['error'].nil?
        unless options[:detailed]
          table = Text::Table.new
          table.head = ['Snapshot', 'State', 'Started', 'Duration']
          table.rows = statuses['snapshots'].map { |s|
            [s["snapshot"],
             s["state"],
             s["start_time"],
             s['end_time_in_millis'].nil? ? 'N/A' : Snapshot.pretty_time(s['end_time_in_millis'] - s['start_time_in_millis']) ]
          }
          puts table
        else
          ap statuses
        end

      end
    end
  end
end
