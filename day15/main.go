package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"math"
	"strings"
)

// Elf : an elf
type Elf struct {
	hp          int
	attackPower int
}

// Goblin : a goblin
type Goblin struct {
	hp          int
	attackPower int
}

// Terrain : a map piece
type Terrain int

const (
	// Wall : a type of piece
	Wall Terrain = iota + 1
	// Open : a type of piece
	Open
)

// Coordinate : an x,y coordinate
type Coordinate struct {
	x int
	y int
}

func main() {
	input, err := ioutil.ReadFile("input1.txt")
	if err != nil {
		log.Fatal(err)
	}

	pieces := parseInput(input)
	for y, line := range pieces {
		for x, piece := range line {
			coordinate := Coordinate{x, y}

			_, elfOk := piece.(Elf)
			if elfOk {
				targetsCoordinates := findGoblins(pieces)

				adjacentTarget, adjcaentTargetErr := findAdjacentTarget(coordinate, targetsCoordinates)
				if adjcaentTargetErr == nil {
					fmt.Printf("I'm already adjacent to %v\n", adjacentTarget)
				}

				// if in range, skip {
				//   identify targets
				//   move if possible by shortest round
				// }
				// attack if possible
				// fmt.Println("Found an Elf")
			}

			_, goblinOk := piece.(Goblin)
			if goblinOk {
				fmt.Println("Found a Goblin")
			}
		}
	}

	printBoard(pieces)
}

func printBoard(pieces [][]interface{}) {
	for _, line := range pieces {
		for _, piece := range line {
			_, elfOk := piece.(Elf)
			if elfOk {
				fmt.Print("E")
			}

			_, goblinOk := piece.(Goblin)
			if goblinOk {
				fmt.Print("G")
			}

			terrain, terrainOk := piece.(Terrain)
			if terrainOk {
				switch terrain {
				case Wall:
					fmt.Print("#")
				case Open:
					fmt.Print(".")
				}
			}

			fmt.Print(" ")
		}

		fmt.Print("\n")
	}
}

func findAdjacentTarget(coordinate Coordinate, targetsCoordinates []Coordinate) (Coordinate, error) {
	for _, targetCoordinate := range targetsCoordinates {
		if coordinateDistance(coordinate, targetCoordinate) == 1 {
			return targetCoordinate, nil
		}
	}

	return Coordinate{x: 0, y: 0}, errors.New("Couldn't find adjacent target")
}

func findGoblins(pieces [][]interface{}) []Coordinate {
	var results []Coordinate
	for x, line := range pieces {
		for y, piece := range line {
			_, ok := piece.(Goblin)
			if ok {
				results = append(results, Coordinate{x, y})
			}
		}
	}
	return results
}

func coordinateDistance(coord1 Coordinate, coord2 Coordinate) int {
	return int(math.Abs(float64(coord1.x-coord2.x))) + int(math.Abs(float64(coord1.y-coord2.y)))
}

func parseInput(input []byte) [][]interface{} {
	var pieces [][]interface{}
	lines := strings.Split(strings.TrimSpace(string(input)), "\n")
	for _, line := range lines {
		var row []interface{}
		for _, char := range line {
			switch char {
			case 'E':
				row = append(row, Elf{hp: 200, attackPower: 3})
			case 'G':
				row = append(row, Goblin{hp: 200, attackPower: 3})
			case '#':
				row = append(row, Wall)
			case '.':
				row = append(row, Open)
			}
		}
		pieces = append(pieces, row)
	}
	return pieces
}
