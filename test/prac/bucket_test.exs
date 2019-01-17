defmodule Prac.BucketTest do
  use ExUnit.Case, async: true

  setup do
     bucket = start_supervised!(Prac.Bucket)
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Prac.Bucket.get(bucket, "milk") == nil

    Prac.Bucket.put(bucket, "milk", 3)
    assert Prac.Bucket.get(bucket, "milk") == 3
  end
#  test "delete/2 returns a key if one exists(temp workers)" do
#    assert Supervisor.child_spec(Prac.Bucket, []).restart == :temporary
#   end

  test "Buckets can be temporary workers" do
    assert Supervise.child_spec(Prac.Bucket, []).restart == :temporary
  end
end