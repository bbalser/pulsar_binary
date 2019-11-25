defmodule Pulsar.Binary do
  alias Pulsar.Proto.BaseCommand

  def simple(%BaseCommand{} = command) do
    binary_command = BaseCommand.encode(command)
    binary_size = byte_size(binary_command)

    <<binary_size + 4::size(32)>> <> <<binary_size::size(32)>> <> binary_command
  end
end
