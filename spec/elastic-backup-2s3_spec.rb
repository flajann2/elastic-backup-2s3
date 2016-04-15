require_relative 'spec_helper'

include ElasticBackup

S3URL = "s3://mybucket/my/path:my_snapshot"
S3URL2 = "s3://mybucket/my/path"

describe Snapshot do
  it "parses the S3 Url" do
    bucket, path, snapshot = Snapshot.s3url_splice(S3URL)
    expect(bucket).to eq("mybucket")
    expect(path).to eq("my/path")
    expect(snapshot).to eq("my_snapshot")
  end

  it "parses the S3 Url without the snapshot" do
    bucket, path, snapshot = Snapshot.s3url_splice(S3URL2)
    expect(bucket).to eq("mybucket")
    expect(path).to eq("my/path")
    expect(snapshot).to eq(nil)
  end

  it "has a valid s3 resource" do
    expect(s3 = Snapshot.s3).to_not be nil
  end

  it "has a valid Elastic resource" do
    expect(Snapshot.elastic).to_not be nil
  end

  it "esurl defaults nicely" do
    expect(Snapshot.esurl).to  eq('http://localhost:9200')
    expect(Snapshot.esurl port: 5900).to  eq('http://localhost:5900')
    expect(Snapshot.esurl suri: 'localhost:5900').to  eq('http://localhost:5900')
  end
end

