defmodule Pulsar.Binary.Connection do
  use Connection
  require Logger

  alias Pulsar.Binary.Commands

  def command(pid, command) do
    GenServer.call(pid, {:command, command})
  end

  def start_link(opts) do
    Connection.start_link(__MODULE__, opts)
  end

  def init(opts) do
    {:connect, nil, Map.new(opts)}
  end

  def connect(_info, state) do
    opts = [:binary, active: :once]

    case :gen_tcp.connect('localhost', 6650, opts) do
      {:ok, socket} ->
        pulsar_connect(socket)
        {:ok, Map.put(state, :socket, socket)}

      {:error, reason} ->
        Logger.warn("TCP connection error: #{inspect(reason)}")
        {:backoff, 1000, state}
    end
  end

  def handle_call({:command, command}, _from, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, command)
    {:reply, :ok, state}
  end

  def handle_info({:tcp, socket, msg}, %{socket: socket} = state) do
    :inet.setopts(socket, active: :once)

    Pulsar.Proto.BaseCommand.decode(msg)
    |> do_handle(socket)

    {:noreply, state}
  end

  def handle_info(unknown, state) do
    Logger.warn("Unknown message: #{inspect(unknown)}")
    {:noreply, state}
  end

  defp pulsar_connect(socket) do
    msg =
      Commands.connect(protocol_version: 6, client_version: "balser")
      |> Pulsar.Binary.simple()

    :ok = :gen_tcp.send(socket, msg)
  end

  defp do_handle(%Pulsar.Proto.BaseCommand{type: :CONNECTED}, _socket) do
    Logger.info("Connected")
  end

  defp do_handle(%Pulsar.Proto.BaseCommand{type: :PING}, socket) do
    Logger.info("PING PONG")

    msg =
      Pulsar.Proto.CommandPong.new()
      |> PulsarProtocol.SimpleCommand.encode()

    :ok = :gen_tcp.send(socket, msg)
  end
end
