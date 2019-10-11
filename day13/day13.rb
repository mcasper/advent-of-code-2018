UP = :up
DOWN = :down
LEFT = :left
RIGHT = :right
STRAIGHT = :straight

TURN_PIECES = ["/", "\\", "+"]

class Cart
  def initialize(x:, y:, direction:)
    @x = x
    @y = y
    @direction = direction
    @next_turn = LEFT
  end

  def char
    case direction
    when UP
      "^"
    when DOWN
      "v"
    when LEFT
      "<"
    when RIGHT
      ">"
    end
  end

  def move(grid)
    case direction
    when UP
      next_piece = grid[y-1][x]
      self.y -= 1
    when DOWN
      next_piece = grid[y+1][x]
      self.y += 1
    when LEFT
      next_piece = grid[y][x-1]
      self.x -= 1
    when RIGHT
      next_piece = grid[y][x+1]
      self.x += 1
    end

    if self.x < 0 || self.y < 0
      require "pry"; binding.pry
    end

    case next_piece
    when "|", "-"
      # nothing
    when "/"
      case direction
      when LEFT
        self.direction = DOWN
      when UP
        self.direction = RIGHT
      when RIGHT
        self.direction = UP
      when DOWN
        self.direction = LEFT
      end
    when "\\"
      case direction
      when LEFT
        self.direction = UP
      when UP
        self.direction = LEFT
      when RIGHT
        self.direction = DOWN
      when DOWN
        self.direction = RIGHT
      end
    when "+"
      self.direction = set_direction
      set_next_turn
    end
  end

  def set_direction
    case self.next_turn
    when LEFT
      case self.direction
      when LEFT
        DOWN
      when RIGHT
        UP
      when UP
        LEFT
      when DOWN
        RIGHT
      end
    when STRAIGHT
      self.direction
    when RIGHT
      case self.direction
      when LEFT
        UP
      when RIGHT
        DOWN
      when UP
        RIGHT
      when DOWN
        LEFT
      end
    end
  end

  def set_next_turn
    case next_turn
    when LEFT
      self.next_turn = STRAIGHT
    when STRAIGHT
      self.next_turn = RIGHT
    when RIGHT
      self.next_turn = LEFT
    end
  end

  def crashed?(carts)
    carts.any? { |other_cart| other_cart.object_id != self.object_id && other_cart.x == x && other_cart.y == y }
  end

  attr_accessor :x, :y, :direction, :next_turn
end

def sort_by_coordinates(carts)
  carts.sort_by { |cart| [cart.y, cart.x] }
end

lines = File.read("input.txt").split("\n")

grid = lines.map(&:chars)
carts = []
grid.each_with_index do |chars, y|
  chars.each_with_index do |char, x|
    case char
    when "^"
      carts << Cart.new(x: x, y: y, direction: UP)
      grid[y][x] = "|"
    when "<"
      carts << Cart.new(x: x, y: y, direction: LEFT)
      grid[y][x] = "-"
    when ">"
      carts << Cart.new(x: x, y: y, direction: RIGHT)
      grid[y][x] = "-"
    when "v"
      carts << Cart.new(x: x, y: y, direction: DOWN)
      grid[y][x] = "|"
    end
  end
end

def print_board(grid, carts)
  grid.each_with_index do |line, y|
    line.each_with_index do |char, x|
      cart = carts.detect { |cart| cart.y == y && cart.x == x }

      if cart
        print cart.char
      else
        print char
      end
    end
    puts
  end
end

crash = nil
i = 0

while crash.nil?
  if i % 10_000_000
    puts "Grid size: #{grid.count}x#{grid.first.count}"
    puts "Card coordinates:"
    carts.each { |cart| puts "  #{cart.x},#{cart.y}" }
  end

  sort_by_coordinates(carts).each do |cart|
    i += 1
    if !carts.include?(cart)
      next
    end

    cart.move(grid)

    if carts.count == 1
      raise "The last cart is at #{cart.x},#{cart.y}: #{cart.inspect}"
    end

    if cart.crashed?(carts)
      # raise "First crash at #{cart.x},#{cart.y}"
      carts = carts.reject { |other_cart| cart.y == other_cart.y && cart.x == other_cart.x }
    end
  end
end
