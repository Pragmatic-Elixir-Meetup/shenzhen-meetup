defmodule Pbt do

  def biggest([head | tail] = _list) do
    find_biggest(tail, head)
  end
  defp find_biggest([], biggest), do: biggest
  defp find_biggest([head | tail], biggest) when head <= biggest do
    find_biggest(tail, biggest)
  end
  defp find_biggest([head | tail], biggest) when head > biggest do
    find_biggest(tail, head)
  end
end
