def to_claim(line)
  id, the_rest = line.split("@")
  coord, size = the_rest.strip.split(":")
  x, y = coord.split(",").map(&:to_i)
  x_size, y_size = size.split("x").map(&:to_i)
  [x, y, x_size, y_size, id]
end

claims = File.read("input.txt").strip.split("\n").map { |line| to_claim(line) }
max_x_claim = claims.max_by { |claim| claim[0] + claim[2] }
max_x = max_x_claim[0] + max_x_claim[2]
max_y_claim = claims.max_by { |claim| claim[1] + claim[3] }
max_y = max_y_claim[1] + max_y_claim[3]

grid = []
max_y.times do
  grid << Array.new(max_x, 0)
end

claims.each do |claim|
  x, y, x_size, y_size, _id = claim

  y.upto(y + y_size - 1).each do |y_coord|
    row = grid[y_coord]
    x.upto(x + x_size - 1).each do |x_coord|
      row[x_coord] += 1
    end
  end
end

no_overlap = nil
claims.each do |claim|
  x, y, x_size, y_size, id = claim

  overlapped = false
  y.upto(y + y_size - 1).each do |y_coord|
    row = grid[y_coord]
    x.upto(x + x_size - 1).each do |x_coord|
      if row[x_coord] > 1
        overlapped = true
      end
    end
  end

  if !overlapped
    no_overlap = id
    break
  end
end

puts "Part 1: #{grid.map { |row| row.select { |coord| coord > 1 }.count }.sum}"
puts "Part 2: #{no_overlap}"

# grid.each do |line|
#   print line
#   print "\n"
# end
