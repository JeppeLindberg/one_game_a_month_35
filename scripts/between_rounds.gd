extends Node3D


var _title
var _damage_needed
var _available_plays
var _difficulty

func _ready():
	_difficulty = get_node("/root/main_scene/difficulty")
	_title = get_node("/root/main_scene/between_rounds/ui/title")
	_damage_needed = get_node("/root/main_scene/between_rounds/ui/damage_needed")
	_available_plays = get_node("/root/main_scene/between_rounds/ui/available_plays")

func update(current_round):
	var difficulty_dict = _difficulty.get_difficulty_dict(current_round)
	_title.set_text("Round " + str(current_round))
	_available_plays.set_text("Available plays: " + str(difficulty_dict["plays"]))
	_damage_needed.set_text("Points needed: " + str(difficulty_dict["damage_needed"]))

