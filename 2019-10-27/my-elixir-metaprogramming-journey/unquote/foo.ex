defmodule Foo do

  # Example 1:
  # reuiqre Foo
  # Foo.bar(unquote(x))
  # => {:unquote, [line: 3], [{:x, [line: 3], nil}]}
  #
  # Example 2:
  # Foo.bar do: unquote(y)
  # => do: {:unquote, [line: 4], [{:y, [line: 4], nil}]}]
  defmacro bar(opts) do
    IO.inspect(opts)
    nil
  end

  # iex(8)> Foo.bar(unquote(x)) do
  #   ...(8)> unquote(y)
  #   ...(8)> end
  #   {:unquote, [line: 8], [{:x, [line: 8], nil}]}
  #   [do: {:unquote, [line: 9], [{:y, [line: 9], nil}]}]
  defmacro bar(head, body) do
    IO.inspect head
    IO.inspect body
    nil
  end

  defmacro barw(x) do
    x
  end
end

defmodule Baz do
  x = 41
  def qux() do
    require Foo
    Foo.barw(1 + unquote(x))
  end
end


