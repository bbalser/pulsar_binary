defmodule Pulsar.Binary.Connection.CommandEncoder do
  props = Pulsar.Proto.BaseCommand.__message_props__()
  field_props = props.field_props
  mapping = Pulsar.Proto.BaseCommand.Type.mapping()

  Enum.each(mapping, fn {type_atom, id} ->
    type = field_props[id].type
    name_atom = field_props[id].name_atom

    def encode(%unquote(type){} = command) do
      Pulsar.Proto.BaseCommand.new([
        {:type, unquote(type_atom)},
        {unquote(name_atom), command}
      ])
      |> Pulsar.Proto.BaseCommand.encode()
    end
  end)
end
