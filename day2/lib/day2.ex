defmodule Day2 do
  @moduledoc """
  Documentation for `Day2`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Day2.hello()
      :world

  """
  def sum(name) do
    input(name)
    |> parseGames()
    |> filterInvalidGames()
    |> Enum.reduce(0, fn {id, _}, sum -> sum + id end)
  end

  def minimumNumberofCubes(name) do
    input(name)
    |> parseGames()
    |> Enum.map(&gameMaxes/1)
    |> Enum.map(&gameMultiple/1)
    |> Enum.reduce(0, &Kernel.+/2)
  end

  def gameMultiple(gameMaxes) do
    gameMaxes
    |> Enum.reduce(1, fn {_color, i}, prod -> i * prod end)
  end

  def gameMaxes({_id, game}) do
    Enum.reduce(game, %{"r" => nil, "g" => nil, "b" => nil}, fn set, maxes ->
      maxes
      |> Enum.map(fn {color, max} ->
        cond do
          Map.get(set, color) == nil ->
            {color, max}

          max == nil ->
            {color, Map.get(set, color)}

          Map.get(set, color) > max ->
            {color, Map.get(set, color)}

          true ->
            {color, max}
        end
      end)
    end)
  end

  def filterInvalidGames(games) do
    games
    |> Enum.filter(&validGame/1)
  end

  def validGame({id, game}) do
    rules = %{"r" => 12, "g" => 13, "b" => 14}

    game =
      Enum.filter(game, fn set ->
        rules
        |> Enum.any?(fn {color, limit} ->
          Map.get(set, color) != nil && Map.get(set, color) > limit
        end)
      end)

    Enum.count(game) == 0
  end

  def parseGames(gameStr) do
    gameStr
    |> Enum.reduce(%{}, &parseRow/2)
  end

  def parseRow(row, acc) do
    [gameId, game] =
      row
      |> String.split(":")

    gameId = gameId |> String.replace("Game ", "") |> String.to_integer()

    game =
      game
      |> String.split(";")
      |> Enum.reduce([], fn str, round ->
        [
          str
          |> String.split(",")
          |> Enum.reduce(%{}, fn color, set ->
            cond do
              String.contains?(color, "red") ->
                Map.put(
                  set,
                  "r",
                  String.replace(color, " red", "") |> String.trim() |> String.to_integer()
                )

              String.contains?(color, "green") ->
                Map.put(
                  set,
                  "g",
                  String.replace(color, " green", "") |> String.trim() |> String.to_integer()
                )

              String.contains?(color, "blue") ->
                Map.put(
                  set,
                  "b",
                  String.replace(color, " blue", "") |> String.trim() |> String.to_integer()
                )
            end
          end)
          | round
        ]
      end)

    Map.put(acc, gameId, game)
  end

  @spec input(charlist()) :: [charlist()]
  def input(name) do
    {:ok, input} = File.read(name)

    input
    |> String.split("\n")
  end
end
