extends Node3D

@export var priority = 0

func _ready():
	add_to_group('resolving_player_turn')

func trigger(phase):
	var parent = get_parent()
	parent.trigger(phase)
	return parent


