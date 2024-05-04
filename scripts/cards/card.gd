extends StaticBody3D

var _control
var _attack_pattern

@export var _command_prefab: PackedScene

func _ready():
	add_to_group('card')
	_control = get_node('/root/main_scene/control')
	_attack_pattern = get_node('attack_pattern')


func mouse_press():
	var command = _command_prefab.instantiate()
	command.card_source = self
	command.attack_positions = []
	
	for attack_marker in _attack_pattern.get_children():
		command.attack_positions.append(attack_marker.position)

	_control.set_command(command)

func card_used():
	queue_free()
