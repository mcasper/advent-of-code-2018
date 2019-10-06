input = ARGV[0]
recipes = [3, 7]
recipes_string = "37"

elf1 = 0
elf2 = 1

runs = 0
start = Time.now.to_i

while 
  (recipes[elf1] + recipes[elf2]).to_s.chars.each { |char| recipes << char.to_i; recipes_string << char }

  elf1 += recipes[elf1] + 1
  until elf1 < recipes.length
    elf1 -= recipes.length
  end

  elf2 += recipes[elf2] + 1
  until elf2 < recipes.length
    elf2 -= recipes.length
  end

  runs += 1
  if runs % 100000 == 0
    puts "Runs: #{runs}"
    puts "Time: #{Time.now.to_i - start}s"

    if recipes_string.include?(input)
      puts recipes_string.index(input)
      break
    end
  end
end
