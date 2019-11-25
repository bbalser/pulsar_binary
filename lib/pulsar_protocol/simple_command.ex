defmodule PulsarProtocol.SimpleCommand do
  alias Pulsar.Proto.BaseCommand

  def encode(%Pulsar.Proto.CommandPong{} = pong) do
    do_encode(type: :PONG, pong: pong)
  end

  def encode(%Pulsar.Proto.CommandConnect{} = connect) do
    do_encode(type: :CONNECT, connect: connect)
  end

  defp do_encode(opts) do
    command =
      BaseCommand.new(opts)
      |> BaseCommand.encode()

    command_size = byte_size(command)
    <<command_size + 4::size(32)>> <> <<command_size::size(32)>> <> command
  end
end
