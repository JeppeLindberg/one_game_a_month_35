extends Node3D

var _difficulty
var _main_scene

@export var _enemy_prefabs: Array[PackedScene]

var _current_round

var _spawn_priority_vecs
var _no_of_gates = 2
var _waves = {}

func _ready():
	_main_scene = get_node('/root/main_scene')
	_difficulty = get_node('/root/main_scene/difficulty')

func clear():
	_waves = {}

func set_round(current_round):
	_current_round = current_round

	var first_priority = []
	var second_priority = []
	if _current_round < 3:
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

func get_enemy_spawns_in_wave(wave):
	var remaining_power = _difficulty.get_difficulty_dict(_current_round)['power']

	if wave not in _waves.keys():
		var new_range = range(wave - (wave % 10), (wave + 10) - (wave % 10))
		new_range.erase(0)

		for i in new_range:
			_waves[i] = []

			if i == 1:
				_waves[i] = [_enemy_prefabs.pick_random(), _enemy_prefabs.pick_random(), _enemy_prefabs.pick_random()]
				remaining_power -= _main_scene.get_enemy_info(_waves[i][0])['power'] + _main_scene.get_enemy_info(_waves[i][1])['power'] + _main_scene.get_enemy_info(_waves[i][2])['power']
		
		while remaining_power > 0:
			var lowest_count = 100
			for i in new_range:
				if len(_waves[i]) < lowest_count:
					lowest_count = len(_waves[i])
			
			var lowest_range = []
			for i in new_range:
				if len(_waves[i]) == lowest_count:
					lowest_range.append(i)
			
			var new_enemy = _enemy_prefabs.pick_random()
			var new_power = _main_scene.get_enemy_info(new_enemy)['power']
			if remaining_power - new_power >= 0:
				_waves[lowest_range.pick_random()].append(new_enemy)
			
			remaining_power -= new_power
	
	return _waves[wave]

