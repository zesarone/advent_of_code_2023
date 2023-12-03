defmodule Day3 do
  def sum(name) do
    schema = input(name)

    cordsPerSymbol =
      findSymbols(schema)
      |> Enum.map(&neighbors(schema, &1))

    {nums, _} = numbers(schema, cordsPerSymbol)

    nums |> Enum.reduce(0, &Kernel.+/2)
  end

  def product(name) do
    schema = input(name)

    cordsPerSymbol =
      findSymbol(schema, "*")
      |> Enum.map(&neighbors(schema, &1))

    numbers2(schema, cordsPerSymbol)
    |> Enum.filter(fn {neighbors, _} ->
      count = Enum.count(neighbors)
      count > 1 && count < 3
    end)
    |> Enum.reduce(0, fn {nums, _}, acc -> acc + Enum.reduce(nums, 1, &Kernel.*/2) end)

    # nums |> Enum.reduce(0, &Kernel.+/2)
  end

  def numbers2(schema, cordsPerSymbol) do
    cordsPerSymbol
    |> Enum.map(fn symbolCords ->
      symbolCords
      |> Enum.reduce({[], []}, fn cord, {savedNums, alreadyUsed} ->
        {num, usedCords} = numberAtXY(schema, cord)

        cond do
          !Enum.any?(usedCords, fn c -> Enum.member?(alreadyUsed, c) end) ->
            {[String.to_integer(num) | savedNums], usedCords ++ alreadyUsed}

          true ->
            {savedNums, alreadyUsed}
        end
      end)
    end)
  end

  def numbers(schema, cordsPerSymbol) do
    {nums, cords} =
      cordsPerSymbol
      |> Enum.reduce({[], []}, fn symbolCords, {savedNums, alreadyUsed} ->
        symbolCords
        |> Enum.reduce({savedNums, alreadyUsed}, fn cord, {savedNums, alreadyUsed} ->
          {num, usedCords} = numberAtXY(schema, cord)

          cond do
            !Enum.any?(usedCords, fn c -> Enum.member?(alreadyUsed, c) end) ->
              {[num | savedNums], usedCords ++ alreadyUsed}

            true ->
              {savedNums, alreadyUsed}
          end
        end)
      end)

    {nums |> Enum.map(&String.to_integer/1), cords}
  end

  def numberAtXY(schema, {x, y}) do
    legal = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    xy = Enum.at(Enum.at(schema, y), x)

    cond do
      Enum.member?(legal, xy) ->
        {leftStr, leftCords} = numberAtLeftXY(schema, {x - 1, y})
        {rightStr, rightCords} = numberAtRightXY(schema, {x + 1, y})
        {leftStr <> xy <> rightStr, leftCords ++ [{x, y} | rightCords]}

      true ->
        {"", []}
    end
  end

  def numberAtLeftXY(schema, {x, y}) do
    legal = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    xy = Enum.at(Enum.at(schema, y), x)

    cond do
      Enum.member?(legal, xy) ->
        {leftStr, leftCords} = numberAtLeftXY(schema, {x - 1, y})
        {leftStr <> xy, leftCords ++ [{x, y}]}

      true ->
        {"", []}
    end
  end

  def numberAtRightXY(schema, {x, y}) do
    legal = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    xy = Enum.at(Enum.at(schema, y), x)

    cond do
      Enum.member?(legal, xy) ->
        {rightStr, rightCords} = numberAtRightXY(schema, {x + 1, y})
        {xy <> rightStr, [{x, y} | rightCords]}

      true ->
        {"", []}
    end
  end

  def neighbors(schema, {x, y}) do
    legalValues = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    # neighbor positions
    [
      {x + 1, y},
      {x + 1, y + 1},
      {x, y + 1},
      {x - 1, y + 1},
      {x - 1, y},
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1}
    ]
    |> Enum.filter(fn {x, y} ->
      cond do
        x >= 0 && y >= 0 && Enum.count(schema) > y && Enum.count(Enum.at(schema, y)) > x ->
          Enum.member?(legalValues, Enum.at(Enum.at(schema, y), x))

        true ->
          false
      end
    end)
  end

  def findSymbols(schema) do
    [_, symbols] =
      schema
      |> Enum.reduce([0, []], fn row, [y, res] ->
        [_, out] =
          row
          |> Enum.reduce([0, res], fn el, [x, result] ->
            illegal = ["", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]

            cond do
              !Enum.member?(illegal, el) -> [x + 1, [{x, y} | result]]
              true -> [x + 1, result]
            end
          end)

        [
          y + 1,
          out
        ]
      end)

    symbols
  end

  def findSymbol(schema, symbol = "*") do
    [_, symbols] =
      schema
      |> Enum.reduce([0, []], fn row, [y, res] ->
        [_, out] =
          row
          |> Enum.reduce([0, res], fn el, [x, result] ->
            cond do
              el == symbol -> [x + 1, [{x, y} | result]]
              true -> [x + 1, result]
            end
          end)

        [
          y + 1,
          out
        ]
      end)

    symbols
  end

  @spec input(charlist()) :: [charlist()]
  def input(name) do
    {:ok, input} = File.read(name)

    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ""))
  end
end
