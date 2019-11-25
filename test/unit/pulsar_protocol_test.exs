defmodule PulsarProtocolTest do
  use ExUnit.Case
  doctest PulsarProtocol

  test "greets the world" do
    assert PulsarProtocol.hello() == :world
  end
end
