defmodule PracTest do
  use ExUnit.Case
  doctest Prac

  test "greets the world" do
    assert Prac.hello() == :world
  end
end
