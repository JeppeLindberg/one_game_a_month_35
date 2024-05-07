extends Node3D

var _round

var _spawn_priority_vecs
var _no_of_gates = 2

func set_round(new_round):
	_round = new_round

	var first_priority = []
	var second_priority = []
	if _round < 3:
		first_priority = [Vector2(1,0), Vector2(2,0), Vector2(3,0)]
		second_priority = [Vector2(0,0), Vector2(4,0)]
	else:
		first_priority = [Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(3,0), Vector2(4,0)]
		second_priority = []
	
	first_priority.shuffle()
	second_priority.shuffle()
	_spawn_priority_vecs = first_priority + second_priority

func get_spawn_order(wave):
	if wave == 1:
		var first_small = _spawn_priority_vecs.slice(0,_no_of_gates)
		for i in range(_no_of_gates):
			first_small[i] = first_small[i] + Vector2.DOWN
		var first_large = first_small + _spawn_priority_vecs.slice(0,_no_of_gates)
		first_large.shuffle()
		var remaining = _spawn_priority_vecs.slice(_no_of_gates)
		remaining.shuffle()
		return first_large + remaining
	else:
		var first = _spawn_priority_vecs.slice(0,_no_of_gates)
		first.shuffle()
		var remaining = _spawn_priority_vecs.slice(_no_of_gates)
		remaining.shuffle()
		return first + remaining;

func get_enemies(wave):
	if wave == 1:
		return 3
	else:
		return wave % 2 + 1

