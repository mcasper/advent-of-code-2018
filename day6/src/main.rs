use std::fs;

#[derive(Debug)]
struct Coordinate {
    x: i32,
    y: i32,
    owned_coordinates: i32,
    infinite: bool,
}

impl From<&str> for Coordinate {
    fn from(string: &str) -> Self {
        let split: Vec<&str> = string.split(", ").collect();
        Coordinate {
            x: split[0].parse().unwrap(),
            y: split[1].parse().unwrap(),
            owned_coordinates: 0,
            infinite: false,
        }
    }
}

fn main() {
    let input: String = String::from_utf8(fs::read("input.txt").unwrap()).unwrap().trim().to_owned();
    let mut coordinates: Vec<Coordinate> = input.split('\n').map(|s| s.into()).collect();
    let max_x = coordinates.iter().max_by(|a, b| a.x.cmp(&b.x)).unwrap().x;
    let max_y = coordinates.iter().max_by(|a, b| a.y.cmp(&b.y)).unwrap().y;

    let mut grid: Vec<Vec<String>> = vec![];

    for y in 0..max_y+2 {
        let mut row = vec![];
        for x in 0..max_x+2 {
            let coordinate = Coordinate{x: x, y: y, owned_coordinates: 0, infinite: false};

            let distances = coordinates.iter().map(|input_coord| manhatten_distance(input_coord, &coordinate)).collect::<Vec<i32>>();
            let min_distance_index = min_index_without_dup(distances.clone());
            match min_distance_index {
                Some(i) => {
                    coordinates[i].owned_coordinates += 1;
                    if coordinate.x == 0 || coordinate.x == max_x || coordinate.y == 0 || coordinate.y == max_y {
                        coordinates[i].infinite = true;
                    }
                    row.push(i.to_string());
                },
                None => {
                    row.push(".".to_owned());
                }
            }
        }
        grid.push(row);
    }

    for row in grid {
        println!("{:?}", row);
    }

    let most_territory = coordinates.iter()
        .filter(|coord| !coord.infinite)
        .max_by_key(|coordinate| coordinate.owned_coordinates).unwrap();
    println!("Part 1: {:?}", most_territory);
}

fn manhatten_distance(a: &Coordinate, b: &Coordinate) -> i32 {
    (a.x - b.x).abs() + (a.y - b.y).abs()
}

fn min_index_without_dup(ints: Vec<i32>) -> Option<usize> {
    let mut i = 0;
    let mut duped = false;

    for (j, &value) in ints.iter().enumerate() {
        if value == ints[i] && j != i {
            duped = true;
        }

        if value < ints[i] {
            duped = false;
            i = j;
        }
    }

    if duped {
        None
    } else {
        Some(i)
    }
}
