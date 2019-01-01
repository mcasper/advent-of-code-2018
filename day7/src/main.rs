#![feature(drain_filter)]

extern crate regex;

use regex::Regex;
use std::fs;

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

#[derive(Debug)]
struct Worker {
    free_in: Option<i32>,
    step: Option<char>,
}

fn main() {
    let input: String = String::from_utf8(fs::read("input.txt").unwrap()).unwrap().trim().to_owned();
    let mut steps: Vec<Step> = input.clone().split('\n').map(|s| s.into()).collect();
    let mut steps_part2: Vec<Step> = input.split('\n').map(|s| s.into()).collect();
    populate_ending_steps(&mut steps);
    populate_ending_steps(&mut steps_part2);
    let mut steps_taken: Vec<char> = vec![];

    while steps.len() > 0 {
        process_steps(&mut steps, &mut steps_taken);
    }

    let mut workers = vec![
        Worker{free_in: None, step: None},
        Worker{free_in: None, step: None},
        Worker{free_in: None, step: None},
        Worker{free_in: None, step: None},
        Worker{free_in: None, step: None},
    ];
    let mut timer = 0;
    let mut steps_taken_part2: Vec<char> = vec![];
    loop {
        free_workers(&mut steps_part2, &mut steps_taken_part2, &mut workers);
        start_workers(&mut steps_part2, &mut workers);

        if workers.iter().all(|worker| worker.step.is_none()) {
            break
        }

        timer += 1;
    }

    let string: String = steps_taken.into_iter().collect();
    println!("Part 1: {}", string);
    println!("Part 2: {}", timer);
}

fn free_workers(remaining_steps: &mut Vec<Step>, steps_taken: &mut Vec<char>, workers: &mut Vec<Worker>) {
    for worker in workers {
        if let Some(free_in) = worker.free_in {
            if free_in == 1 {
                worker.free_in = None;
                remaining_steps.drain_filter(|step| step.id == worker.step.unwrap());
                steps_taken.push(worker.step.unwrap());
                worker.step = None;
            } else {
                worker.free_in = Some(worker.free_in.unwrap() - 1);
            }
        }
    }
}

fn start_workers(remaining_steps: &mut Vec<Step>, workers: &mut Vec<Worker>) {
    let mut steps_without_prereq_or_worker: Vec<Step> = remaining_steps
        .clone()
        .into_iter()
        .filter(|step| !remaining_steps.iter().any(|step2| step2.prereq_to == step.id))
        .filter(|step| !workers.iter().any(|worker| worker.step == Some(step.id)))
        .collect();
    steps_without_prereq_or_worker.sort_by(|a, b| (a.id as i32).cmp(&(b.id as i32)));
    steps_without_prereq_or_worker.dedup_by_key(|step| step.id);

    for worker in workers {
        if worker.free_in.is_none() && !steps_without_prereq_or_worker.is_empty() {
            let step = steps_without_prereq_or_worker.remove(0);
            worker.free_in = Some(60 + (step.id as i32) - 64);
            worker.step = Some(step.id);
        }
    }
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
