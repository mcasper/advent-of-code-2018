#![feature(drain_filter)]

extern crate chrono;

use chrono::{DateTime, TimeZone, Timelike, Utc};
use std::collections::HashMap;
use std::fs;

#[derive(Debug)]
struct Event {
    datetime: DateTime<Utc>,
    event: String,
}

impl From<&str> for Event {
    fn from(string: &str) -> Self {
        let (datetime_string, event_string) = string.split_at(18);
        let datetime = Utc.datetime_from_str(datetime_string, "[%Y-%m-%d %H:%M]").unwrap();
        Event {
            datetime: datetime,
            event: event_string.trim().to_owned(),
        }
    }
}

#[derive(Clone, Debug)]
struct Guard {
    id: i32,
    asleep_at: Option<DateTime<Utc>>,
    minutes: Vec<u32>,
}

impl PartialEq for Guard {
    fn eq(&self, other: &Guard) -> bool {
        self.id == other.id
    }
}

fn process_event(event: &Event, guards: &mut Vec<Guard>) {
    match event.event.as_ref() {
        "falls asleep" => {
            let mut guard = guards.pop().unwrap();
            guard.asleep_at = Some(event.datetime.clone());
            guards.push(guard);
        },
        "wakes up" => {
            let mut guard = guards.pop().unwrap();
            let mut minutes_asleep: Vec<u32> = (guard.asleep_at.unwrap().minute()..event.datetime.minute()).collect();
            guard.asleep_at = None;
            guard.minutes.append(&mut minutes_asleep);
            guards.push(guard);
        },
        guard_id => {
            let (_, part1) = guard_id.split_at(7);
            let id = part1.replace(" begins shift", "");
            let parsed_id: i32 = id.parse().unwrap();

            let filtered_guards: Vec<Guard> = guards.drain_filter(|guard| guard.id == parsed_id).collect();
            if filtered_guards.len() > 1 {
                panic!("Duplicate guards");
            } else if filtered_guards.len() == 1 {
                let guard = filtered_guards[0].clone();
                guards.push(guard);
            } else {
                guards.push(Guard{id: parsed_id, asleep_at: None, minutes: vec![]});
            }
        },
    }
}

fn main() {
    let input_data: String = String::from_utf8(fs::read("input/part_1.txt").unwrap()).unwrap();
    let mut events: Vec<Event> = input_data.trim().split('\n').map(|input| input.into()).collect();
    events.sort_by(|a, b| a.datetime.cmp(&b.datetime));

    let mut guards = vec![];
    for event in events {
        process_event(&event, &mut guards);
    }

    let guard_most_asleep = guards.iter().max_by(|a,b| a.minutes.len().cmp(&b.minutes.len())).unwrap();
    let mut grouped_minutes: HashMap<u32, u32> = HashMap::new();
    for minute in guard_most_asleep.minutes.clone() {
        if grouped_minutes.contains_key(&minute) {
            grouped_minutes.insert(minute, grouped_minutes.get(&minute).unwrap() + 1);
        } else {
            grouped_minutes.insert(minute, 1);
        }
    }

    let (k,v) = grouped_minutes.iter().max_by(|(_, av), (_, bv)| av.cmp(&bv)).unwrap();
    println!("{:?}", guard_most_asleep);
    println!("{:?}", grouped_minutes);
    if v < &2 {
        panic!("Count of sleep isn't greater than 1");
    }
    println!("Part 1: Guard {}, Minute: {}, total: {}", guard_most_asleep.id, k, guard_most_asleep.id * *k as i32)
}
