input = ARGV[0].to_i
recipes = [3, 7]

elf1 = 0
elf2 = 1

runs = 0

while 
  runs += 1

  (recipes[elf1] + recipes[elf2]).to_s.chars.each { |char| recipes << char.to_i }

  elf1 += recipes[elf1] + 1
  until elf1 < recipes.length
    elf1 -= recipes.length
  end

  elf2 += recipes[elf2] + 1
  until elf2 < recipes.length
    elf2 -= recipes.length
  end

  if runs > (input + 10)
    break
  end
end

puts "Score: #{recipes[input..input+9].join}"
