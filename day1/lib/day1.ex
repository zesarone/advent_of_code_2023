defmodule Day1 do
  @moduledoc """
  Documentation for `Day1`.
  """

  @spec sum_example() :: integer()
  def sum_example do
    input("example")
    |> sum
  end
  @spec sum_example2() :: integer()
  def sum_example2 do
    input("example2")
    |> sum2
  end

  @spec sum_input() :: integer()
  def sum_input do
    input("input")
    |> sum
  end

  @spec sum_input2() :: integer()
  def sum_input2 do
    input("input")
    |> sum2
  end

  @spec sum(charlist()) :: integer()
  def sum(input) do
    input
    |> Enum.map( &dropNonNumericals/1 )
    |> Enum.map( & addFirstAndLastElements/1 )
    |> Enum.map( &( String.to_integer(&1)) )
    |> Enum.reduce( &( &1 + &2))
  end

  @spec sum2(charlist()) :: integer()
  def sum2(input) do
    input
    |> Enum.map( &replaceTextNumbersWithNumber/1 )
    |> Enum.map( &dropNonNumericals/1 )
    |> Enum.map( &addFirstAndLastElements/1 )
    |> Enum.map( &String.to_integer/1 )
    |> Enum.reduce( &( &1 + &2))
  end

  @spec addFirstAndLastElements([[charlist()]]) :: binary()
  def addFirstAndLastElements(row) do
    Enum.at(row,0) <> "" <> Enum.at(row,-1)
  end

  @spec replaceTextNumbersWithNumber([charlist()]) :: [charlist()]
  def replaceTextNumbersWithNumber(row) do
    [
      ["one","o1ne"],
      ["two","t2wo"],
      ["three","th3ree"],
      ["four","fo4ur"],
      ["five","fi5ve"],
      ["six","si6x"],
      ["seven","se7ven"],
      ["eight","eig8ht"],
      ["nine","ni9ne"]]
    |> Enum.reduce(row, fn [s,r], acc ->
      String.replace(acc, s, r)
    end)
  end

  @spec dropNonNumericals([charlist()]) :: [[charlist()]]
  def dropNonNumericals(row) do
    row
    |> String.split("")
    |> Enum.filter(fn
      "" -> false
      <<v::utf8>> -> v >= 48 && v <= 57
    end)

  end

  @spec input(charlist()) :: [charlist()]
  def input(name) do
    {:ok, input} = File.read(name)
    input
    |> String.split("\n")
  end
end
