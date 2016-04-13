require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


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

end

