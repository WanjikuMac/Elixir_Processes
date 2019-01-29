defmodule Prac.Registry do
  use GenServer

  #client API
  @doc """
   Starts the registry
  """
  @spec start_link(any()):: pid()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
   Looks up the bucket pid for `name` stored in `server`

    Returns `{:ok, pid}` if the bucket exists, `:error` otherwise
  """
 # @spec lookup(tuple()):: {:ok, String.t()}
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
   Ensures there is a bucket associated with the given `name` in `server`
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  @doc """
   Stop the registry
  """
  def stop(server) do
    GenServer.stop(server)
  end

  #server callbacks
  @doc """
    receives second argument given to the Genserver.start_link and returns
    {:ok, state} -- state is a new map
  """
  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end
  @doc """
  Parameters
    `{:lookup, name}` - request from client server
    `_from` - process from which we received the request
    `names` -current server state/ new_state
  """
  def handle_call({:lookup, name}, _from, state) do
    {names, _} =state
    {:reply, Map.fetch(names, name), state}
  end

  @doc """
    Parameters
    `{:create, name}` - request from client API
    `names` -- current server state
  """
  def handle_cast({:create, name}, {names, refs}) do #using handle_cast for illustration purposes, in real world this should be handle_call since you expect a response
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}} #tuple inform of {:noreply, new_state}
    else
      {:ok, pid} = DynamicSupervisor.start_child(Prac.BucketSupervisor, Prac.Bucket)
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, pid)
      {:noreply,{names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end