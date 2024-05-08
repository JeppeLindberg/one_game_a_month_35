extends Node3D

var _game_manager
var _main_scene

@export var card_prefabs: Array[PackedScene]

var _remaining_upgrade_choices = 3

func _ready():
	_main_scene = get_node('/root/main_scene')
	_game_manager = get_node('/root/main_scene/game_manager')

func generate_upgrade_choice():
	var card = _main_scene.instantiate(card_prefabs.pick_random())
	card.move_to_upgrade_choice()

func trigger(phase):
	if phase == 'prepare_upgrade_choice':
		if _remaining_upgrade_choices > 0:
			generate_upgrade_choice()
			_remaining_upgrade_choices -= 1			
			_game_manager.resolve_node(self, false)
			return
		else:
			_game_manager.resolve_node(self, true)
			return
		

