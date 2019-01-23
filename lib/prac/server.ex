defmodule Prac.Server do
  use GenServer

  @name :attendees_server

 defmodule State do
   @type t :: __MODULE__
   @moduledoc """
   This module holds our notification's server state
    field in the struct:
    * `attendees` - the delegates present
  """
   defstruct [attendees: []]
  end
  #Client server
  @doc """
  This function resets the state of the server
  """
  @spec reset_state() :: any()
  def reset_state do
    GenServer.call(@name, :reset)
  end
  @spec start_link(any())::tuple()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  @spec add(String.t()):: {:ok, list(String.t())}
  def add(name) do
  GenServer.cast(@name, {:add, name})
  end

  @spec remove(String.t()) :: {:ok, list(String.t())}
  def remove(name) do
    GenServer.cast(@name, {:remove, name})
  end

  @spec attendees() :: {:ok, list(String.t())}
  def attendees do
    GenServer.call(@name, :attendees)
  end

  #server callbacks

  def init(:ok) do
    {:ok, %{}}
  end
  @spec handle_cast(tuple(), pid()) :: {tuple(),State.t()}
  def handle_cast({:add, name}, state) do
    attendees = Prac.Attendees.find(name)
    new_state = Map.put(state, name, attendees)
    {:noreply, new_state}
  end

  @spec handle_cast(tuple(), pid()) ::{tuple(), State.t()}
  def handle_cast({:remove, name}, state) do
    new_state = Map.delete(state, name)
    {:noreply, new_state}
  end

  @spec handle_call(atom(), pid(), State.t()) :: {atom(), tuple(), State.t()}
  def handle_call(:attendees, _from, state) do
    {:reply, state, state}
  end

  @doc """
  This callback handles reset of the server state that is used while running tests
  """
  def handle_call(:reset, _from, _state) do
    {:reply, {:ok, %State{}, %State{}}}
  end
end