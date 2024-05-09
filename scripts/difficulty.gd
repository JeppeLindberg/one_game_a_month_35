extends Node3D



func get_difficulty_dict(current_round):
	return _difficulty[current_round]

var _difficulty = {
	1: {
		'power': 200, # Power per 10 waves, power = health*threat
		'plays': 8,
		'damage_needed': 100
	},
	2: {
		'power': 250,
		'plays': 9,
		'damage_needed': 120
	},
	3: {
		'power': 300,
		'plays': 10,
		'damage_needed': 150
	},
	4: {
		'power': 350,
		'plays': 10,
		'damage_needed': 190
	}
}

