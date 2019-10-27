defmodule MacroPhilosophy do
  def hello(name) do
    "Hello #{name}!"
  end

  defmacro hello2(name) do
    quote bind_quoted: [name: name] do
      "Hello #{name}"
    end
  end
end

defmodule UselessExamplesAreFun do
  defmacro log_number_of_expressions(code) do
    {_, counter} = Macro.prewalk code, 0, fn(expr, counter) ->
      {expr, counter + 1}
    end

    IO.puts "You passed me #{counter} expressions/sub-expressions"

    code
  end
end
