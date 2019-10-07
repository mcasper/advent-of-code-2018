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
opcode_results = []

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

  opcode_results << [inputs.first, matching_operations]
end

OPCODES_TO_OPERATION = {
  0 => Operations::Seti,
  1 => Operations::Eqir,
  2 => Operations::Setr,
  3 => Operations::Gtir,
  4 => Operations::Addi,
  5 => Operations::Muli,
  6 => Operations::Mulr,
  7 => Operations::Gtrr,
  8 => Operations::Bani,
  9 => Operations::Gtri,
  10 => Operations::Bori,
  11 => Operations::Banr,
  12 => Operations::Borr,
  13 => Operations::Eqri,
  14 => Operations::Eqrr,
  15 => Operations::Addr,
}

opcode_results.group_by { |opcode, _| opcode }.each do |opcode, results|
  next if OPCODES_TO_OPERATION[opcode]

  result_sets = results.map { |_, result| result - OPCODES_TO_OPERATION.values }
  union = result_sets.reduce { |a, b| a & b }
  if union.count == 1
    puts "#{opcode} => #{union.first}"
  end
end

puts "Part 1 Answer: #{answer}"

input2 = File.read('input2.txt').strip.split("\n")
registers = Registers.from_array([0, 0, 0, 0])
input2.each do |line|
  inputs = line.split(" ").map(&:to_i)
  registers = OPCODES_TO_OPERATION[inputs.first].call(
    registers: registers,
    inputs: inputs,
  )
end

puts registers.inspect
