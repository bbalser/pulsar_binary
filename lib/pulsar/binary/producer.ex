defmodule Pulsar.Binary.Producer do
  defstruct topic: nil,
            producer_id: nil

  require Pulsar.Binary.Commands, as: Commands

  def create(conn, topic) do
    msg =
       Commands.producer(topic: topic, producer_id: 1, request_id: 0, metadata: [])
       |> Pulsar.Binary.simple()

    Pulsar.Binary.Connection.command(conn, msg)
  end
end
