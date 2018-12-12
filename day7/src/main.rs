#![feature(drain_filter)]

extern crate regex;

use std::fs;
use regex::Regex;

#[derive(Clone, Debug)]
struct Step {
    id: char,
    prereq_to: char,
}

impl From<&str> for Step {
    fn from(string: &str) -> Self {
        let re = Regex::new(r"Step ([A-Z]{1}) must be finished before step ([A-Z]{1}) can begin.").unwrap();
        let captures = re.captures(string).unwrap();
        Step {
            id: captures[1].chars().nth(0).unwrap(),
            prereq_to: captures[2].chars().nth(0).unwrap(),
        }
    }
}

fn main() {
    let input: String = String::from_utf8(fs::read("input.txt").unwrap()).unwrap().trim().to_owned();
    let mut steps: Vec<Step> = input.split('\n').map(|s| s.into()).collect();
    populate_ending_steps(&mut steps);
    let mut steps_taken: Vec<char> = vec![];

    while steps.len() > 0 {
        process_steps(&mut steps, &mut steps_taken);
    }

    let string: String = steps_taken.into_iter().collect();
    println!("Part 1: {}", string);
}

fn process_steps(remaining_steps: &mut Vec<Step>, steps_taken: &mut Vec<char>) {
    let mut steps_without_prereq: Vec<Step> = remaining_steps
        .clone()
        .into_iter()
        .filter(|step| !remaining_steps.iter().any(|step2| step2.prereq_to == step.id))
        .collect();

    steps_without_prereq.sort_by(|a, b| (a.id as i32).cmp(&(b.id as i32)));
    let step_to_take = steps_without_prereq.iter().nth(0).unwrap();
    let _ = remaining_steps.drain_filter(|step| step.id == step_to_take.id);
    steps_taken.push(step_to_take.id);
}

fn populate_ending_steps(steps: &mut Vec<Step>) {
    let ending_steps: Vec<Step> = steps
        .clone()
        .into_iter()
        .filter(|step| !steps.iter().any(|step2| step2.id == step.prereq_to))
        .collect();

    for step in ending_steps {
        steps.push(Step{id: step.prereq_to.clone(), prereq_to: '?'});
    }
}
