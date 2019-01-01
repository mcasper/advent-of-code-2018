class Star
  def initialize(line:)
    parts = line.scan(/-?\d+/)
    @x = parts[0].to_i
    @y = parts[1].to_i
    @x_velocity = parts[2].to_i
    @y_velocity = parts[3].to_i
  end

  attr_accessor :x, :y, :x_velocity, :y_velocity
end

def display_stars(stars)
  max_x = stars.max_by { |s| s.x }.x
  max_y = stars.max_by { |s| s.y }.y

  min_x = stars.min_by { |s| s.x }.x
  min_y = stars.min_by { |s| s.y }.y

  x_length = max_x + min_x.abs + 1
  y_length = max_y + min_y.abs + 1
  arr = Array.new(x_length, " ")

  grid = []
  y_length.times do
    grid << arr
  end

  stars.each do |star|
    y_index = star.y + min_y.abs
    x_index = star.x + min_x.abs

    grid[y_index][x_index] = "#"
  end

  grid.each { |line| print line.join(" ") }
end

def find_area(stars)
  max_x = stars.max_by { |s| s.x }.x
  max_y = stars.max_by { |s| s.y }.y
  min_x = stars.min_by { |s| s.x }.x
  min_y = stars.min_by { |s| s.y }.y

  (max_x - min_x) + (max_y - min_y)
end

def move_stars(stars)
  stars.each do |star|
    star.x += star.x_velocity
    star.y += star.y_velocity
  end
end

input = File.read("input.txt").strip
stars = input.split("\n").map { |line| Star.new(line: line) }
second = 0
playing = true

# display_stars(stars)

min_area = 1_000_000_000_000
min_second = 1_000_000_000_000

while playing
  move_stars(stars)
  area = find_area(stars)
  if min_area > area
    min_area = area
    min_second = second
  end

  if second == 10_521
    playing = false
    display_stars(stars)
  end

  if second == 1_000_000
    playing = false
  end
  second += 1
end

puts min_area
puts min_second
