defmodule Pulsar.Binary.Connection do
  use Connection
  require Logger

  require Pulsar.Binary.Commands, as: Commands

  def command(pid, command) do
    GenServer.call(pid, {:command, command})
  end

  def start_link(opts) do
    Connection.start_link(__MODULE__, opts)
  end

  def init(opts) do
    state = %{
      host: Keyword.fetch!(opts, :host) |> to_charlist(),
      port: Keyword.get(opts, :port, 6650),
      request_id: 0
    }

    {:connect, nil, state}
  end

  def connect(_info, state) do
    opts = [:binary, active: false]

    with {:ok, socket} <- :gen_tcp.connect(state.host, state.port, opts),
         :ok <- pulsar_connect(socket) do
      {:ok, Map.put(state, :socket, socket)}
    else
      {:error, reason} ->
        Logger.warn("Failed to establish connection to Pulsar: #{inspect(reason)}")
        {:backoff, 1000, state}
    end
  end

  def handle_call({:command, command}, _from, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, command)
    {:reply, :ok, state}
  end

  def handle_info({:tcp, socket, msg}, %{socket: socket} = state) do
    :inet.setopts(socket, active: :once)

    Pulsar.Binary.decode(msg)
    |> do_handle(socket)

    {:noreply, state}
  end

  def handle_info(unknown, state) do
    Logger.warn("Unknown message: #{inspect(unknown)}")
    {:noreply, state}
  end

  defp pulsar_connect(socket) do
    msg =
      Commands.connect(protocol_version: 6, client_version: "pulsar_binary 0.1")
      |> Pulsar.Binary.simple()

    :ok = :gen_tcp.send(socket, msg)

    with {:ok, packet} <- :gen_tcp.recv(socket, 0),
         Commands.connected() <- Pulsar.Binary.decode(packet) do
      Logger.debug("#{__MODULE__}:(#{inspect(self())}) - Client is connected")
      :inet.setopts(socket, active: :once)
      :ok
    end
  end

  defp do_handle(Commands.ping(), socket) do
    Logger.debug("#{__MODULE__}:(#{inspect(self())}) - Ping Pong")

    msg =
      Commands.pong([])
      |> Pulsar.Binary.simple()

    :ok = :gen_tcp.send(socket, msg)
  end

  defp do_handle(Commands.producer_success!(), socket) do
    IO.inspect(command, label: "Command")
    :ok
  end
end
