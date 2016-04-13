module ElasticBackup
  module Snapshot

    # Take the s3 url and break it down to
    # its components [BUCKET, PATH, SNAPSHOT]
    def self.s3url_splice(surl)
      protocol, b, snapshot = surl.split(':')
      empty, empty, bucket, path = b.split('/', 4)
      [bucket, path, snapshot]
    end

    def self.elastic


    def self.get_index_list
    end

  end
end
