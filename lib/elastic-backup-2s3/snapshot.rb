# -*- coding: utf-8 -*-
module ElasticBackup
  module Snapshot
    class << self
      def s3
        @s3 ||= Aws::S3::Resource.new
      end

      def opt
        @opt
      end

      # We only need to set this once anyway
      def set_opts(options)
        @opt ||= options
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

      # For now, this will overwrite the repo if it is
      # there already.
      def set_repository s3url
        bucket, base_path, _ignore = s3url_splice s3url
        cmd = { repository: opt[:repo], 
          body: {
            type: 's3',
            settings:  { 
              bucket: bucket,
              base_path: base_path
            }}}
        ap cmd if opt[:dryrun] || (opt[:verbose] >= 2)
        unless opt[:dryrun]
          ret = MultiJson.load elastic.snapshot.create_repository(cmd)
          ap ret unless opt[:verbose] < 2
          raise "Error #{ret['status']} detected: #{ret['error']}" unless ret['error'].nil?
        end
      end

      def initiate_snapshot s3url
        _ignore, _ignore, snapname = s3url_splice s3url
        raise "Must specify :SNAPSHOTNAME at the end of your S3URL #{s3url}" if snapname.nil?

        cmd = { 
          repository: opt[:repo], 
          snapshot: snapname,
          wait_for_completion: opt[:wait],
          master_timeout: opt[:timeout],
          body: {}}
        cmd[:body][:indices] = opt[:indices].join(',') unless opt[:indices].nil?
        ap cmd if opt[:dryrun] || (opt[:verbose] >= 2)
        unless opt[:dryrun]
          ret = MultiJson.load elastic.snapshot.create(cmd)
          ap ret unless opt[:verbose] < 2
          raise "Error #{ret['status']} detected: #{ret['error']}" unless ret['error'].nil?
        end
      end

      def initiate_restore s3url
        _ignore, _ignore, snapname = s3url_splice s3url
        raise "Must specify :SNAPSHOTNAME at the end of your S3URL #{s3url}" if snapname.nil?

        cmd = { 
          repository: opt[:repo], 
          snapshot: snapname,
          wait_for_completion: opt[:wait],
          master_timeout: opt[:timeout]
        }
        ap cmd if opt[:dryrun] || (opt[:verbose] >= 2)
        unless opt[:dryrun]
          ret = MultiJson.load elastic.snapshot.restore(cmd)
          ap ret unless opt[:verbose] < 2
          raise "Error #{ret['status']} detected: #{ret['error']}" unless ret['error'].nil?
        end
      end

      # Do a snapshot of an elasticsearch cluster
      def snapshot esurl, s3url, options
        elastic esurl
        set_opts(options)
        set_repository s3url
        initiate_snapshot s3url
      end
      
      def restore s3url, esurl, options
        elastic esurl
        set_opts(options)
        set_repository s3url
        initiate_restore s3url
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
