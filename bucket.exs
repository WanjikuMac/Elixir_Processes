defmodule Bucket do
  #This file is in the root folder since, I ran it on iex
  #This is done by running c "bucket.exs" then press enter. Boom, you can
  #Start your server and interact with it, run basic things
  use Agent, restart: :temporary

  @doc """
    Start a new bucket
  """
  #@spec start_link(opts)
  def start_link(opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Takes a value from the `bucket` by `key`
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
  Deletes `key` from `bucket`

  Returns the current value of `key` if `key` exists
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, fn dict -> Map.pop(dict,key) end)
  end
end