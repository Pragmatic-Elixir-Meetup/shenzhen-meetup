defmodule MyMacro do
  defmacro make_methods(numbers) do
    Enum.map numbers, fn (num) ->
      quote do
        def unquote(:"say_#{num}")() do
          IO.puts unquote(num)
        end
      end
    end
  end

  defmacro def_method(number) do
    quote bind_quoted: [number: number] do
      def unquote(:"def_#{number}")() do
        IO.inspect unquote(number)
      end
    end
  end
end

defmodule Run do
  import MyMacro

  make_methods([1,2])

  def run do
    say_1()
    say_2()
  end

  for n <- [1,2] do
    def_method(n)
  end

  def run1 do
    def_1()
    def_2()
  end
end
