defmodule Prac.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(Prac.Registry)
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert Prac.Registry.lookup(registry, "basket") == :error

    Prac.Registry.create(registry, "basket")
    assert {:ok, bucket} = Prac.Registry.lookup(registry, "basket")

    Prac.Bucket.put(bucket, "milk", 1)
    assert Prac.Bucket.get(bucket, "milk") == 1
  end

  test "removes bucket on exit", %{registry: registry} do
    Prac.Registry.create(registry,"basket")
    {:ok, bucket} = Prac.Registry.lookup(registry, "basket")
    Agent.stop(bucket)
    assert Prac.Registry.lookup(registry, "basket") == :error
  end
end