class Registers
  def initialize(registers:)
    @registers = registers
  end

  attr_reader :registers

  def self.from_array(array)
    new(registers: array.map { |el| Register.new(value: el) })
  end

  def get_register(index)
    registers[index].value
  end

  def set_register(index, value)
    registers[index] = Register.new(value: value)
    self
  end

  def clone
    Registers.new(
      registers: registers.map { |r| Register.new(value: r.value) }
    )
  end

  def eq?(other_registers)
    registers.map.with_index do |register, i|
      register.value == other_registers.get_register(i)
    end.all?
  end
end

class Register
  def initialize(value:)
    @value = value
  end

  attr_reader :value
end

module Operations
  class Base
    def self.call(registers:, inputs:)
      raise NotImplementedError
    end
  end

  class Addr < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        registers.get_register(a) + registers.get_register(b),
      )
    end
  end

  class Addi < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        registers.get_register(a) + b,
      )
    end
  end

  class Mulr < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        registers.get_register(a) * registers.get_register(b),
      )
    end
  end

  class Muli < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        registers.get_register(a) * b,
      )
    end
  end

  class Banr < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        registers.get_register(a) & registers.get_register(b),
      )
    end
  end

  class Bani < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        registers.get_register(a) & b,
      )
    end
  end

  class Borr < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        registers.get_register(a) | registers.get_register(b),
      )
    end
  end

  class Bori < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        registers.get_register(a) | b,
      )
    end
  end

  class Setr < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, _, c = inputs
      copied_registers.set_register(
        c,
        registers.get_register(a),
      )
    end
  end

  class Seti < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        a,
      )
    end
  end

  class Gtir < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        a > copied_registers.get_register(b) ? 1 : 0,
      )
    end
  end

  class Gtri < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        copied_registers.get_register(a) > b ? 1 : 0,
      )
    end
  end

  class Gtrr < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        copied_registers.get_register(a) > copied_registers.get_register(b) ? 1 : 0,
      )
    end
  end

  class Eqir < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        a == copied_registers.get_register(b) ? 1 : 0,
      )
    end
  end

  class Eqri < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        copied_registers.get_register(a) == b ? 1 : 0,
      )
    end
  end

  class Eqrr < Base
    def self.call(registers:, inputs:)
      copied_registers = registers.clone
      opcode, a, b, c = inputs
      copied_registers.set_register(
        c,
        copied_registers.get_register(a) == copied_registers.get_register(b) ? 1 : 0,
      )
    end
  end
end

operations = Operations.constants.reject { |o| o == :Base }.map { |o| Object.const_get("Operations::#{o}") }
answer = 0

input = File.read('input.txt').strip.split("\n").reject { |line| line.empty? }
input.each_slice(3) do |lines|
  before, inputs, after = lines
  starting_registers = Registers.from_array(eval(before.gsub('Before: ', '')))
  ending_registers = Registers.from_array(eval(after.gsub('After: ', '')))
  inputs = inputs.split(" ").map(&:to_i)

  matching_operations = operations.select do |operation|
    result = operation.call(registers: starting_registers, inputs: inputs)
    ending_registers.eq?(result)
  end

  if matching_operations.count >= 3
    answer += 1
  end
end

puts "Answer: #{answer}"
