extern crate regex;

use regex::Regex;
use std::fs;

struct Game {
    current_player: usize,
    current_marble_index: usize,
    next_marble_value: i64,
    marbles: Vec<Marble>,
}

struct Marble {
    value: i64,
}

fn main() {
    let input: String = String::from_utf8(fs::read("example.txt").unwrap()).unwrap().trim().to_owned();
    let re = Regex::new(r"(\d+) players; last marble is worth (\d+) points").unwrap();
    let captures = re.captures(&input).unwrap();
    let num_players = captures[1].parse::<usize>().unwrap();
    let mut players = vec![0; num_players];
    let last_marble_value = captures[2].parse::<i64>().unwrap();
    let mut game = Game{current_player: 0, current_marble_index: 0, next_marble_value: 1, marbles: vec![Marble{value: 0}]};

    let mut playing = true;
    while playing {
        let next_marble = Marble{value: game.next_marble_value};
        if next_marble.value == last_marble_value {
            playing = false
        }

        if next_marble.value % 23 == 0 {
            players[game.current_player] += next_marble.value;
            let removal_index = find_removal_index(game.marbles.len(), game.current_marble_index);
            let removed_marble = game.marbles.remove(removal_index);
            players[game.current_player] += removed_marble.value;
            game.current_marble_index = removal_index
        } else {
            let insert_index = index_one_two_counter_clockwise(game.marbles.len(), game.current_marble_index);
            game.current_marble_index = insert_index;
            game.marbles.insert(insert_index, next_marble);
        }

        game.next_marble_value += 1;
        game.current_player += 1;
        if game.current_player == players.len() {
            game.current_player = 0;
        }

        if game.next_marble_value % 1000 == 0 {
            println!("{} / {}", game.next_marble_value, last_marble_value);
        }
    }

    let max_score = players.iter().max().unwrap();
    println!("Max score: {}", max_score);
}

fn print_board(game: &Game) {
    let mut display = String::new();
    for (index, marble) in game.marbles.iter().enumerate() {
        if game.current_marble_index == index {
            display.push_str(&format!(" ({})", marble.value));
        } else {
            display.push_str(&format!(" {}", marble.value));
        }
    }
    println!("{}", display);
}

fn index_one_two_counter_clockwise(length: usize, current_index: usize) -> usize {
    if current_index + 2 > length {
        current_index + 2 - length
    } else {
        current_index + 2
    }
}

fn find_removal_index(length: usize, current_index: usize) -> usize {
    if current_index < 7 {
        current_index + length - 7
    } else {
        current_index - 7
    }
}
