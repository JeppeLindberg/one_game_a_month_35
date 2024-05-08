extends StaticBody3D

var _control
var _hand
var _main_scene

@export var _bell_command_prefab: PackedScene


func _ready():
	add_to_group('bell')
	_main_scene = get_node('/root/main_scene')
	_control = get_node('/root/main_scene/control')
	_hand = get_node('/root/main_scene/round/hand')

func mouse_press():
	if len(_hand.get_cards_in_hand()) < 5:
		var command = _main_scene.instantiate(_bell_command_prefab)
		_control.set_command(command)

