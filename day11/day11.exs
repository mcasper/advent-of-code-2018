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

  def generate_three_by_threes(grid) do
    Enum.flat_map(0..297, fn x ->
      Enum.map(0..297, fn y ->
        {
          [
            grid |> Enum.at(x) |> Enum.at(y),
            grid |> Enum.at(x+1) |> Enum.at(y),
            grid |> Enum.at(x+2) |> Enum.at(y),
            grid |> Enum.at(x) |> Enum.at(y+1),
            grid |> Enum.at(x+1) |> Enum.at(y+1),
            grid |> Enum.at(x+2) |> Enum.at(y+1),
            grid |> Enum.at(x) |> Enum.at(y+2),
            grid |> Enum.at(x+1) |> Enum.at(y+2),
            grid |> Enum.at(x+2) |> Enum.at(y+2),
          ],
          {x+1,y+1}
        }
      end)
    end)
  end
end

# grid_serial_number = 18
grid_serial_number = 2694
grid = Day11.generate_power_levels(grid_serial_number)
three_by_threes = Day11.generate_three_by_threes(grid)
{three_by_three, {top_left_x, top_left_y}} = Enum.max_by(three_by_threes, fn {grid, _} -> Enum.sum(grid) end)
IO.puts("#{top_left_x},#{top_left_y}: #{Enum.sum(three_by_three)}")
