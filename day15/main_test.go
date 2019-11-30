package main

import (
	"testing"
)

func TestElf(t *testing.T) {
	elf := Elf{
		hp:          300,
		attackPower: 3,
	}

	if elf.hp != 300 || elf.attackPower != 3 {
		t.Errorf("Elf doesn't look right: %v", elf)
	}
}
