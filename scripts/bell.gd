extends StaticBody3D

var _control
var _hand

@export var _bell_command_prefab: PackedScene


func _ready():
	add_to_group('bell')
	_control = get_node('/root/main_scene/control')
	_hand = get_node('/root/main_scene/round/hand')

func mouse_press():
	if len(_hand.get_cards_in_hand()) < 5:
		var command = _bell_command_prefab.instantiate()
		_control.set_command(command)

