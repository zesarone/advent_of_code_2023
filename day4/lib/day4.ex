defmodule Day4 do
  @moduledoc """
  Documentation for `Day4`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Day4.hello()
      :world

  """
  def sum(name) do
    input(name)
    |> parseCards()
    |> Enum.map(&points/1)
    |> Enum.reduce(0, fn %{points: p}, sum -> p + sum end)
  end

  def sum2(name) do
    cards =
      input(name)
      |> parseCards()
      |> Enum.map(&points2/1)

    cards
    |> applyWinningAndCount()
  end

  def applyWinningAndCount(cards), do: applyWinningAndCount(cards, cards, 0)
  def applyWinningAndCount([], _, count), do: count

  def applyWinningAndCount(cards = [%{cardId: id, points: points} | rest], originals, count) do
    extras =
      cond do
        points > 0 ->
          Enum.slice(originals, (id + 1)..(id + points)) |> applyWinningAndCount(originals, 0)

        true ->
          0
      end

    applyWinningAndCount(rest, originals, count + 1 + extras)
  end

  def points2(%{cardId: id, winning: winning, draws: draws}) do
    %{
      cardId: id,
      winning: winning,
      points:
        draws
        |> Enum.reduce(0, fn num, points ->
          cond do
            Enum.member?(winning, num) ->
              points + 1

            true ->
              points
          end
        end)
    }
  end

  def points(%{cardId: id, winning: winning, draws: draws}) do
    %{
      cardId: id,
      points:
        draws
        |> Enum.reduce(0, fn num, points ->
          cond do
            Enum.member?(winning, num) ->
              if points == 0 do
                1
              else
                points * 2
              end

            true ->
              points
          end
        end)
    }
  end

  def parseCards(rows) do
    rows
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(fn [card, nums] ->
      [winning, draws] =
        String.split(nums, "|")
        |> Enum.map(&String.trim(&1, " "))
        |> Enum.map(&String.split(&1, " "))
        |> Enum.map(fn nums ->
          nums
          |> Enum.filter(&(&1 != ""))
          |> Enum.map(fn num -> String.trim(num) |> String.to_integer() end)
        end)

      id = String.replace(card, "Card ", "") |> String.trim() |> String.to_integer()

      %{
        cardId: id - 1,
        winning: winning,
        draws: draws
      }
    end)
  end

  @spec input(charlist()) :: [charlist()]
  def input(name) do
    {:ok, input} = File.read(name)

    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end
end
