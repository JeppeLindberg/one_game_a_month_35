extends Node3D

var _main_scene
var _hand
var _draw_pile
var _game_manager


func _ready():
	add_to_group('command')
	_main_scene = get_node('/root/main_scene')
	_hand = get_node('/root/main_scene/hand')
	_draw_pile = get_node('/root/main_scene/draw_pile')
	_game_manager = get_node('/root/main_scene/game_manager')

func _commit_bell():
	_game_manager.resolve_player_turn()

func mouse_move(_event):
	pass

func mouse_press(_event):
	pass

func mouse_release(_event):
	_commit_bell()

func trigger(phase):
	if phase == 'resolving_player_turn':
		if len(_hand.get_cards_in_hand()) < 5:
			var draw_card = _main_scene.get_children_in_groups(_draw_pile, ['card']).pick_random()
			draw_card.move_to_hand()
			_game_manager.resolve_node(self, false)
			return
		else:
			_game_manager.resolve_node(self, true)
			return