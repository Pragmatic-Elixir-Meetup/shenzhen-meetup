defmodule StatusReason do
  for line <- File.stream!(Path.join([__DIR__, "../../status_reason.txt"]), [], :line) do
    [code, reason] = line |> String.split("|") |> Enum.map(&String.trim(&1))

    code_in_integer = String.to_integer(code)
    def reason_from_code(unquote(code_in_integer)), do: unquote(reason)
    def code_from_reason(unquote(reason)), do: unquote(code_in_integer)
  end

  def reason_from_code(_), do: "Unassigned"
end