defmodule M do
  defmacro m(x) do
    IO.inspect(x, label: __MODULE__)

    quote bind_quoted: [x: Macro.escape(x, unquote: true)] do
      def unquote(x)() do
        unquote(x)
      end
    end
    |> IO.inspect(label: "end of module M")
  end
end

# T.a => :a
# T.b => :b
# T.c => :c
defmodule T do
  import M

  for x <- ~w(a b c)a do
    m(unquote(x))
    #  Or, you don't need M module, and instead code follows
    #
    # def unquote(x)() do
    #   unquote(x)
    # end
  end
end
