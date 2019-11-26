defmodule Pulsar.Binary.Commands do
  props = Pulsar.Proto.BaseCommand.__message_props__()
  field_props = props.field_props
  mapping = Pulsar.Proto.BaseCommand.Type.mapping()

  Enum.each(mapping, fn {type_atom, id} ->
    type = field_props[id].type
    name_atom = field_props[id].name_atom

    [
      defmacro unquote(name_atom)(opts) when is_list(opts) do
        type = unquote(type)

        quote do
          struct!(unquote(type), unquote(opts))
        end
      end,
      defmacro unquote(name_atom)(variable) do
        type_atom = unquote(type_atom)
        name_atom = unquote(name_atom)

        quote do
          %Pulsar.Proto.BaseCommand{
            :type => unquote(type_atom),
            unquote(name_atom) => var!(unquote(variable))
          }
        end
      end,
      defmacro unquote(name_atom)() do
        inner_type_atom = unquote(type_atom)

        quote do
          %Pulsar.Proto.BaseCommand{
            :type => unquote(inner_type_atom)
          }
        end
      end
    ]
  end)
end
