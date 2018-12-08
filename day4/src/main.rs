extern crate chrono;

use std::fs;
use chrono::{DateTime, TimeZone, Utc};

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

fn main() {
    let input_data: String = String::from_utf8(fs::read("input/part_1.txt").unwrap()).unwrap();
    let events: Vec<Event> = input_data.trim().split('\n').map(|input| input.into()).collect();
    println!("{:?}", events[0]);
    println!("{:?}", events[1]);
}
