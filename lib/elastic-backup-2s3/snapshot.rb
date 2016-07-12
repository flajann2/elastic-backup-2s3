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

      # return a pretty time format from milliseconds
      def pretty_time(milliseconds)
        secs  = milliseconds / 1000
        mins  = secs / 60
        hours = mins / 60
        days  = hours / 24

        if days > 0
          "#{days} days #{hours % 24} hours"
        elsif hours > 0
          "#{hours} hours #{mins % 60} mimutes"
        elsif mins > 0
          "#{mins} minutes #{secs % 60} seconds"
        elsif secs > 0
          "#{secs} seconds"
        else
          "#{milliseconds} milliseconds"
        end
      end

      # Take the s3 url and break it down to
      # its components [BUCKET, PATH, SNAPSHOT]
      def snapurl_splice(surl)
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
      def set_repository snapurl, opt
        bucket, base_path, _ignore = opt[:fs] ? [nil, nil, nil] : snapurl_splice(snapurl)
        Elasticsearch::API.settings[:skip_parameter_validation] = true
        cmd = { repository: opt[:repo], verify: (not opt[:nv]),
          body: unless opt[:fs]
                  {
              type: 's3',
              settings:  { 
                bucket: bucket,
                base_path: base_path
              }}
                else
                  {
              type: 'fs',
              settings:  { 
                location: [opt[:sharedvol], opt[:postamble]].compact.join('/'),
                max_snapshot_bytes_per_sec: opt[:snapmax], 
                max_restore_bytes_per_sec:  opt[:remax]    
              }}
                end
        }
        ap cmd if opt[:dryrun] || (opt[:verbose] >= 2)
        unless opt[:dryrun]
          ret = MultiJson.load elastic.snapshot.create_repository(cmd)
          ap ret unless opt[:verbose] < 2
          raise "Error #{ret['status']} detected: #{ret['error']}" unless ret['error'].nil?
        end
      end

      def initiate_snapshot snapurl
        _ignore, _ignore, snapname = (opt[:fs] ? [nil, nil, snapurl] : snapurl_splice(snapurl))
        raise "Must specify :SNAPSHOTNAME at the end of your S3URL #{snapurl}" if snapname.nil?

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

      def initiate_restore snapurl
        _ignore, _ignore, snapname = (opt[:fs] ? [nil, nil, snapurl] : snapurl_splice(snapurl))
        raise "Must specify :SNAPSHOTNAME at the end of your S3URL #{snapurl}" if snapname.nil?

        cmd = {
          repository: opt[:repo], 
          snapshot: snapname,
          wait_for_completion: opt[:wait],
          master_timeout: opt[:timeout],
          body: {}}
        cmd[:body][:indices] = opt[:indices].join(',') unless opt[:indices].nil?
        ap cmd if opt[:dryrun] || (opt[:verbose] >= 2)
        unless opt[:dryrun]
          ret = MultiJson.load elastic.snapshot.restore(cmd)
          ap ret unless opt[:verbose] < 2
          raise "Error #{ret['status']} detected: #{ret['error']}" unless ret['error'].nil?
        end
      end

      # Do a snapshot of an elasticsearch cluster
      def snapshot esurl, snapurl, options
        elastic esurl
        set_opts(options)
        set_repository snapurl, options
        initiate_snapshot snapurl
      end
      
      def restore snapurl, esurl, options
        elastic esurl
        set_opts(options)
        set_repository snapurl, options
        initiate_restore snapurl
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
