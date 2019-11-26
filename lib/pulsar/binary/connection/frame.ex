defmodule Pulsar.Binary.Connection.Frame do
  alias Pulsar.Proto.BaseCommand

  def simple(binary_command) do
    binary_size = byte_size(binary_command)

    <<binary_size + 4::size(32)>> <> <<binary_size::size(32)>> <> binary_command
  end

  def payload(%BaseCommand{} = command) do
  end
end
