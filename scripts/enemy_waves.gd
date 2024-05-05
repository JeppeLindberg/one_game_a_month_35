extends Node3D

var _round

var _spawn_priority_vecs

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
		var first_2 = _spawn_priority_vecs.slice(0,2)
		for i in range(2):
			first_2[i] = first_2[i] + Vector2.DOWN
		var next_2 = first_2 + _spawn_priority_vecs.slice(0,2)
		next_2.shuffle()
		var next_3 = _spawn_priority_vecs.slice(2,5)
		next_3.shuffle()
		return first_2 + next_2 + next_3
	else:
		return _spawn_priority_vecs;

