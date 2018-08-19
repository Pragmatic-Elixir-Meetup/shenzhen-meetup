defmodule ThinkingInPropertyTest do
  use ExUnit.Case
  use ExUnitProperties

  property "finds biggest element" do
    check all int_list <- nonempty(list_of(integer())) do
      assert Pbt.biggest(int_list) == model_biggest(int_list)
    end
  end

  def model_biggest(list) do
    list |> Enum.sort() |> List.last()
  end

  property "picks the last number" do
    check all {list, known_last} <- tuple_of_listNinteger() do
      known_list = list ++ [known_last]
      assert known_last == List.last(known_list)
    end
  end

  def tuple_of_listNinteger() do
    tuple({list_of(integer()), integer()})
  end

  def is_ordered([a, b | tail]) do
    a <= b and is_ordered([b | tail])
  end

  def is_ordered(_) do
    true
  end

  describe "Within a sorted list" do
    property "the elements are ordered" do
      check all list <- list_of(term()) do
        assert list |> Enum.sort() |> is_ordered()
      end
    end

    property "no element is added" do
      check all num_list <- list_of(integer()) do
        sorted = Enum.sort(num_list)
        assert Enum.all?(sorted, fn element -> element in num_list end)
      end
    end

    property "no element is deleted" do
      check all num_list <- list_of(integer()) do
        sorted = Enum.sort(num_list)
        assert Enum.all?(num_list, fn element -> element in sorted end)
      end
    end

    property "symmetric encoding/decoding" do
      check all data <- list_of(tuple({atom(:alphanumeric), term()})) do
        encoded = encode(data)
        assert is_binary(encoded)
        assert data == decode(encoded)
      end
    end

    def encode(t), do: :erlang.term_to_binary(t)
    def decode(t), do: :erlang.binary_to_term(t)

    property "in/2 returns true for elements taken out of a list" do
      check all list <- list_of(integer()),
                list != [],
                elem <- member_of(list) do
        assert elem in list
      end
    end
  end
end
