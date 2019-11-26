defmodule Pulsar.Binary.Connection do
  use Connection
  require Logger

  require Pulsar.Binary.Commands, as: Commands
  alias Pulsar.Binary.Connection.CommandEncoder
  alias Pulsar.Binary.Connection.Frame
  alias Pulsar.Binary.Connection.Message

  defmodule State do
    defstruct host: nil,
              port: nil,
              socket: nil,
              next_request_id: 0,
              next_producer_id: 0,
              requests: nil
  end

  def start_link(opts) do
    Connection.start_link(__MODULE__, opts)
  end

  def init(opts) do
    state = %State{
      host: Keyword.fetch!(opts, :host) |> to_charlist(),
      port: Keyword.get(opts, :port, 6650),
      requests: %{}
    }

    {:connect, nil, state}
  end

  def connect(_info, state) do
    opts = [:binary, active: false]

    with {:ok, socket} <- :gen_tcp.connect(state.host, state.port, opts),
         :ok <- pulsar_connect(socket) do
      {:ok, %{state | socket: socket}}
    else
      {:error, reason} ->
        Logger.warn("Failed to establish connection to Pulsar: #{inspect(reason)}")
        {:backoff, 1000, state}
    end
  end

  def handle_call(:next_producer_id, _from, %{next_producer_id: next_producer_id} = state) do
    {:reply, next_producer_id, %{state | next_producer_id: next_producer_id + 1}}
  end

  def handle_call({:command, command}, from, %{socket: socket, requests: requests} = state) do
    {prepared_command, new_state} = Message.prepare(command, state)

    IO.inspect(prepared_command, label: "Prepared Command")
    message = prepared_command |> CommandEncoder.encode() |> Frame.simple()
    :ok = :gen_tcp.send(socket, message)
    {:noreply, %{new_state | requests: Map.put(requests, prepared_command.request_id, from)}}
  end

  def handle_info({:tcp, socket, msg}, %{socket: socket} = state) do
    :inet.setopts(socket, active: :once)
    IO.inspect(state, label: "State")

    new_state =
      Message.decode(msg)
      |> do_handle(state)

    {:noreply, new_state}
  end

  def handle_info(unknown, state) do
    Logger.warn("Unknown message: #{inspect(unknown)}")
    {:noreply, state}
  end

  defp pulsar_connect(socket) do
    msg =
      Commands.connect(protocol_version: 6, client_version: "pulsar_binary 0.1")
      |> CommandEncoder.encode()
      |> Frame.simple()

    :ok = :gen_tcp.send(socket, msg)

    with {:ok, packet} <- :gen_tcp.recv(socket, 0),
         Commands.connected() <- Message.decode(packet) do
      Logger.debug("#{__MODULE__}:(#{inspect(self())}) - Client is connected")
      :inet.setopts(socket, active: :once)
      :ok
    end
  end

  defp do_handle(Commands.ping(), state) do
    Logger.debug("#{__MODULE__}:(#{inspect(self())}) - Ping Pong")

    msg =
      Commands.pong([])
      |> CommandEncoder.encode()
      |> Frame.simple()

    :ok = :gen_tcp.send(state.socket, msg)
    state
  end

  defp do_handle(Commands.producer_success(command), state) do
    request_id = command.request_id
    reply_to_request(state, request_id, command)
  end

  defp do_handle(%Pulsar.Proto.CommandError{request_id: request_id} = command, state) do
    reply_to_request(state, request_id, command)
  end

  defp do_handle(command, state) do
    IO.inspect(command, label: "UNKNOWN command")
    state
  end

  defp reply_to_request(%{requests: requests} = state, request_id, response) do
    case Map.get(requests, request_id) do
      nil ->
        Logger.warn("#{__MODULE__}:(#{inspect(self())}) - Unable to find request for request_id #{request_id}")
        state
      pid ->
        GenServer.reply(pid, response)
        %{state | requests: Map.delete(requests, request_id)}
    end
  end
end
