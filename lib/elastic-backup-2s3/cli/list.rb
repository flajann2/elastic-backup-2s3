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

      desc 'snaphots [S3URL]', 'List all snapshots stored at S3URL'
      def snapshots
      end

    end
  end
end
