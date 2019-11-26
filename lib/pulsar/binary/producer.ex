defmodule Pulsar.Binary.Producer do
  defstruct topic: nil,
            producer_id: nil

  require Pulsar.Binary.Commands, as: Commands

  def create(conn, topic) do
    producer_id = GenServer.call(conn, :next_producer_id)

    command =
      Commands.producer(topic: topic, producer_id: producer_id, request_id: 0, metadata: [])

    GenServer.call(conn, {:command, command})
  end
end
