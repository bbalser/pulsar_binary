defmodule Pulsar.Binary.Commands do
  props = Pulsar.Proto.BaseCommand.__message_props__()
  field_props = props.field_props
  mapping = Pulsar.Proto.BaseCommand.Type.mapping()

  Enum.each(mapping, fn {type_atom, id} ->
    type = field_props[id].type
    name_atom = field_props[id].name_atom

    def unquote(name_atom)(opts) do
      command = struct!(unquote(type), opts)

      Pulsar.Proto.BaseCommand.new([{:type, unquote(type_atom)}, {unquote(name_atom), command}])
      |> Pulsar.Proto.BaseCommand.encode()
    end
  end)

  Enum.each(mapping, fn {type_atom, id} ->
    name_atom = field_props[id].name_atom
    capture_function = :"#{name_atom}!"

    [
      defmacro unquote(name_atom)() do
        inner_name_atom = unquote(name_atom)
        inner_type_atom = unquote(type_atom)

        quote do
          %Pulsar.Proto.BaseCommand{
            :type => unquote(inner_type_atom),
            unquote(inner_name_atom) => _command
          }
        end
      end,
      defmacro unquote(capture_function)() do
        inner_name_atom = unquote(name_atom)
        inner_type_atom = unquote(type_atom)

        quote do
          %Pulsar.Proto.BaseCommand{
            :type => unquote(inner_type_atom),
            unquote(inner_name_atom) => var!(command)
          }
        end
      end
    ]
  end)
end
