module ElasticBackup
  module Snapshot
    class << self
      def s3
        @s3 ||= Aws::S3::Resource.new
      end

      # Take the s3 url and break it down to
      # its components [BUCKET, PATH, SNAPSHOT]
      def s3url_splice(surl)
        protocol, b, snapshot = surl.split(':')
        empty, empty, bucket, path = b.split('/', 4)
        raise "Protocol must be 's3' in #{surl}" unless protocol.downcase == 's3'
        [bucket, path, snapshot]
      end
 
      def esurl(suri: 'localhost', port: 9200)
        _suri, _port = suri.split(':') 
        "http://#{_suri}:#{_port || port}"
      end

      # The first time this is called must have a 
      # valid esurl!!!!
      def elastic(esurl = nil)
        @elastic ||= ESClient.new esurl
      end

      def get_index_list
      end
    end

    class ESClient
      include Elasticsearch::API
      attr :conn

      def initialize(esurl)
        @conn = ::Faraday::Connection.new url: esurl
      end

      def perform_request(method, path, params, body)
        conn.run_request method.downcase.to_sym, path,
        ( body ? MultiJson.dump(body) : nil ),
        {'Content-Type' => 'application/json'}
      end
    end    
  end
end
