defmodule PulsarProtocol do
  def connect(pid) do
    command =
      Pulsar.Proto.CommandConnect.new(protocol_version: 6, client_version: "pulsar_binary_1.0")
      |> Pulsar.Proto.CommandConnect.encode()

    command_size = byte_size(command)
    msg = <<command_size + 4>> <> <<command_size>> <> command

    PulsarProtocol.Connection.command(pid, msg)
  end
end
