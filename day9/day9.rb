class Player
  def initialize
    @score = 0
  end

  def to_s
    "Score: #{score}"
  end

  attr_accessor :score
end

def find_insert_index(current_marble, length)
  if current_marble + 2 > length
    current_marble + 2 - length
  else
    current_marble + 2
  end
end

def find_removal_index(current_marble, length)
  if current_marble - 7 < 0
    current_marble - 7 + length
  else
    current_marble - 7
  end
end

def display_board(current_marble_index, marbles)
  vals = []

  marbles.each_with_index do |marble, i|
    if i == current_marble_index
      vals << "(#{marble})"
    else
      vals << marble.to_s
    end
  end

  puts vals.join(" ")
end

input = File.read("example_input.txt")
num_players, last_marble_value = input.scan(/\d+/)

players = num_players.to_i.times.map { |_| Player.new }
current_player = 0
playing = true
marbles = [0]
current_marble_index = 0
next_marble_value = 1

# display_board(current_marble_index, marbles)

while playing
  player = players[current_player]

  if next_marble_value % 23 == 0
    player.score += next_marble_value
    removal_index = find_removal_index(current_marble_index, marbles.count)
    removed_marble = marbles.delete_at(removal_index)
    player.score += removed_marble
    current_marble_index = removal_index
  else
    insert_index = find_insert_index(current_marble_index, marbles.count)
    marbles = marbles.insert(insert_index, next_marble_value)
    current_marble_index = insert_index
  end

  if next_marble_value == last_marble_value.to_i
    playing = false
    break
  end

  next_marble_value += 1
  current_player += 1
  if current_player == players.count
    current_player = 0
  end

  # display_board(current_marble_index, marbles)
end

puts players
puts "High score is: #{players.max_by { |p| p.score }.score}"
