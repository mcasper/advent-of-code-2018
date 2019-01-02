defmodule Day11 do
  def calculate_power_level(x, y, grid_serial_number) do
    rack_id = x + 10
    power_level = rack_id * y
    power_level = power_level + grid_serial_number
    power_level = power_level * rack_id

    hundreds_place = power_level
                     |> to_string()
                     |> String.split("")
                     |> Enum.filter(fn elem -> elem != "" end)
                     |> Enum.reverse()
                     |> Enum.at(2)

    case hundreds_place do
      nil -> -5
      string -> String.to_integer(string) - 5
    end
  end

  def generate_power_levels(grid_serial_number) do
    Enum.map(1..300, fn x ->
      Enum.map(1..300, fn y ->
        calculate_power_level(x, y, grid_serial_number)
      end)
    end)
  end

  def generate_coords() do
    Enum.flat_map(0..299, fn x ->
      Enum.map(0..299, fn y ->
        {x,y}
      end)
    end)
  end

  def generate_squares({x,y}) do
    max_x = 299 - x
    max_y = 299 - y
    square_size = Enum.min([max_x, max_y])

    IO.puts("Generating squares for #{x},#{y}")

    Enum.map(0..(square_size-1), fn size ->
      Enum.map(0..size, fn x_size ->
        Enum.map(0..size, fn y_size ->
          {x + x_size, y + y_size}
        end)
      end)
    end)
  end

  def generate_power_levels(grid, squares) do
    Task.async_stream(squares, fn rows ->
      square = List.flatten(rows)
      top_left = Enum.at(square, 0)
      size = Enum.count(square) |> :math.sqrt() |> Kernel.trunc()
      IO.puts("Working on #{elem(top_left, 0)},#{elem(top_left, 1)},#{size}")

      {
        Enum.map(square, fn {x,y} ->
          grid |> Enum.at(x) |> Enum.at(y)
        end),
        {elem(top_left, 0)+1,elem(top_left, 1)+1},
        size,
      }
    end, timeout: 300_000)
  end
end

# grid_serial_number = 18
# answer: 90,269,16
grid_serial_number = 2694
grid = Day11.generate_power_levels(grid_serial_number)
coords = Day11.generate_coords()

Enum.map(coords, fn coord ->
  squares = Day11.generate_squares(coord)
  tuples = Enum.to_list(Day11.generate_power_levels(grid, squares))

  {:ok, {square, {top_left_x, top_left_y}, square_size}} = Enum.max_by(tuples, fn {:ok, {power_levels, _, _}} ->
    Enum.sum(power_levels)
  end)

  File.write!("output", "#{top_left_x},#{top_left_y},#{square_size} - power level: #{Enum.sum(square)}\n", [:append])
end)
