use std::fs;
use std::str::Chars;

fn process(chars: Chars, level: i32) -> String {
    let mut pass_along = String::new();
    // println!("Chars count: {}", chars.clone().count());
    let mut peekable = chars.peekable();
    let mut recurse = false;
    while let Some(character) = peekable.next() {
        let next_character_peek = peekable.peek();
        if next_character_peek.is_none() {
            pass_along.push(character);
            continue
        }

        match (character.is_ascii_lowercase(), next_character_peek.unwrap().is_ascii_lowercase()) {
            (false, false) => {
                // AA
                // println!("Miss: {}{}, level: {}", character, next_character_peek.unwrap(), level);
                pass_along.push(character);
            },
            (false, true) => {
                if character.to_ascii_lowercase() == next_character_peek.unwrap().to_ascii_lowercase() {
                    // Aa
                    // println!("Hit: {}{}, level: {}", character, next_character_peek.unwrap(), level);
                    recurse = true;
                    peekable.next();
                } else {
                    // Ab
                    // println!("Miss: {}{}, level: {}", character, next_character_peek.unwrap(), level);
                    pass_along.push(character);
                }
            },
            (true, false) => {
                if character.to_ascii_lowercase() == next_character_peek.unwrap().to_ascii_lowercase() {
                    // aA
                    // println!("Hit: {}{}, level: {}", character, next_character_peek.unwrap(), level);
                    recurse = true;
                    peekable.next();
                } else {
                    // bA
                    // println!("Miss: {}{}, level: {}", character, next_character_peek.unwrap(), level);
                    pass_along.push(character);
                }
            },
            (true, true) => {
                // aa
                // println!("Miss: {}{}, level: {}", character, next_character_peek.unwrap(), level);
                pass_along.push(character);
            },
        }
    }

    if recurse {
        // println!("Recursing with {} chars, next level: {}", pass_along.chars().count(), level+1);
        process(pass_along.chars(), level+1)
    } else {
        pass_along
    }
}

fn main() {
    let input: String = String::from_utf8(fs::read("input.txt").unwrap()).unwrap().trim().to_owned();
    let processed_input = process(input.chars(), 1);
    println!("Part 1: {}", processed_input.chars().count());
}
