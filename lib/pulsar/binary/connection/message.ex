defmodule Pulsar.Binary.Connection.Message do
  alias Pulsar.Binary.Connection.State
  require Logger

  def decode(message) do
    Pulsar.Proto.BaseCommand.decode(message)
  rescue
    e ->
      Logger.warn("#{inspect(e)}")
      Pulsar.Proto.CommandError.decode(message)
  end

  def prepare(
        %Pulsar.Proto.CommandProducer{} = command,
        %State{next_request_id: next_request_id} = state
      ) do
    {%{command | request_id: next_request_id}, %{state | next_request_id: next_request_id + 1}}
  end

  def prepare(command, %State{} = state) do
    {command, state}
  end
end
