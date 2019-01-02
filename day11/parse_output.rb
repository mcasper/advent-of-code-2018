lines = File.read("output").split("\n")

max =lines.max_by do |line|
  top_left_x, top_left_y, square_size, power_level = line.match(/(\d+),(\d+),(\d+) - power level: -?(\d+)/).captures
  power_level.to_i
end

puts max
