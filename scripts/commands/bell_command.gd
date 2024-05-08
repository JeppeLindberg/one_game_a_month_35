extends Node3D

var _main_scene
var _hand
var _draw_pile
var _discard_pile
var _game_manager

var _move_cards_from_discard_to_draw_pile = false


func _ready():
	add_to_group('command')
	_main_scene = get_node('/root/main_scene')
	_hand = get_node('/root/main_scene/round/hand')
	_draw_pile = get_node('/root/main_scene/round/draw_pile')
	_discard_pile = get_node('/root/main_scene/round/discard_pile')
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
		if _move_cards_from_discard_to_draw_pile:
			if len(_main_scene.get_children_in_groups(_discard_pile, ['card'])) != 0:
				var move_card = _main_scene.get_children_in_groups(_discard_pile, ['card']).pick_random()
				move_card.move_to_draw_pile()
				_game_manager.resolve_node(self, false, 0.05)
				return
			else:
				_move_cards_from_discard_to_draw_pile = false
				_game_manager.resolve_node(self, false)
				return

		elif len(_hand.get_cards_in_hand()) < 5:
			if len(_main_scene.get_children_in_groups(_draw_pile, ['card'])) == 0:
				_move_cards_from_discard_to_draw_pile = true
				_game_manager.resolve_node(self, false)
				return

			var draw_card = _main_scene.get_children_in_groups(_draw_pile, ['card']).pick_random()
			draw_card.move_to_hand()
			_game_manager.resolve_node(self, false)
			return
		else:
			_game_manager.resolve_node(self, true)
			return
