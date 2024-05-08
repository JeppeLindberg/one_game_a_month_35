extends Node3D

@export var priority = 0

func _ready():
	add_to_group('prepare_upgrade_choice')

func trigger(phase):
	var parent = get_parent()
	parent.trigger(phase)


