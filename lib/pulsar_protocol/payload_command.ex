defmodule PulsarProtocol.PayloadCommand do
  @magic_number <<14, 1>>

  def encode(%Pulsar.Proto.CommandSend{} = send) do
    do_encode(type: :SEND, send: send)
  end

  defp do_encode(opts) do
    command =
      BaseCommand.new(opts)
      |> BaseCommand.encode()

    command_size = byte_size(command)
  end
end
