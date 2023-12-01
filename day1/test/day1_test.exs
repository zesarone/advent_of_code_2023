defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "sum example" do
    assert Day1.sum_example() == 142
  end
  test "sum input" do
    assert Day1.sum_input() == 54601
  end

  test "sum examples2" do
    assert Day1.sum_example2() == 281
  end
  test "sum input2" do
    assert Day1.sum_input2() == 54078
  end
end
