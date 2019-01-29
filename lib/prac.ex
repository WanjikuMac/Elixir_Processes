defmodule Prac do
  use Application

  def start(_type, _args) do
    Prac.Supervise.start_link(name: Prac.Supervise)
  end
end
