defmodule WorlockTest do
  use ExUnit.Case
  doctest Worlock

  test "greets the world" do
    assert Worlock.hello() == :world
  end
end
