use std::fs;

fn main() {
    let input_data: String = String::from_utf8(fs::read("input/part_1.txt").unwrap()).unwrap();
    let inputs: Vec<&str> = input_data.trim().split('\n').collect();
    let result = inputs.iter().fold(0, |acc, input| {
        acc + input.parse::<i32>().unwrap()
    });

    println!("{}", result);
}
