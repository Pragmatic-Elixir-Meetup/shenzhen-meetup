defmodule RevertTest do
  use ExUnit.Case
  use ExUnitProperties

  test "Test reverse" do
    assert reverse([]) == []
    assert reverse([1]) == [1]
    assert reverse([1, 2, 3]) == [3, 2, 1]
    assert reverse(0..10) == Enum.to_list(10..0)
  end

  property "Reverse a reverse doesn't change" do
    check all list <- list_of(integer()) do
      IO.inspect(list)
      assert reverse(reverse(list)) == list
    end
  end

  property "sorting" do
    generator =
      list_of(integer())

    check all numbers <- generator do
      # IO.inspect numbers
      the_largest = numbers |> Enum.sort() |> List.last()
      assert the_largest == Enum.max(numbers)
    end
  end

  def reverse(seq) do
    seq |> Enum.member?(53) |> has_number_53(seq)
  end

  def has_number_53(true, seq),  do: [53]
  def has_number_53(false, seq), do: Enum.reverse(seq)
end

