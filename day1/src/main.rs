use std::fs;
use std::collections::HashMap;

fn main() {
    let input_data: String = String::from_utf8(fs::read("input/part_1.txt").unwrap()).unwrap();
    let inputs: Vec<&str> = input_data.trim().split('\n').collect();
    let part_1_result = inputs.iter().fold(0, |acc, input| {
        acc + input.parse::<i32>().unwrap()
    });

    let mut known_frequencies: HashMap<i32, i32> = HashMap::new();
    let mut part_2_result = 0;
    let mut solved = false;
    let mut counter = 0;
    while !solved {
        for input in inputs.iter() {
            counter = counter + input.parse::<i32>().unwrap();
            if known_frequencies.contains_key(&counter) && !solved {
                part_2_result = counter;
                solved = true;
            } else {
                known_frequencies.insert(counter, 1);
            }
        }
    }

    println!("Part 1: {}", part_1_result);
    println!("Part 2: {}", part_2_result);
}
