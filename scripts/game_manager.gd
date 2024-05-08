extends Node3D

var _main_scene
var _debug
var _enemy_spawner
var _deck
var _board
var _hand
var _draw_pile
var _control
var _round
var _upgrade
var _copy

var phase = 'none'
var _ignoring_triggers = []
var _resolving_node = null

var _remaining_plays = 8
var _target_damage = 100
var _dealt_damage = 0

func _ready():
	_main_scene = get_node('/root/main_scene')
	_board = get_node('/root/main_scene/round/board')
	_hand = get_node('/root/main_scene/round/hand')
	_deck = get_node('/root/main_scene/deck')
	_copy = get_node('/root/main_scene/copy')
	_draw_pile = get_node('/root/main_scene/round/draw_pile')
	_control = get_node('/root/main_scene/control')
	_enemy_spawner = get_node('/root/main_scene/round/enemy_spawner')
	_debug = get_node('/root/main_scene/debug')
	_round = get_node('/root/main_scene/round')
	_upgrade = get_node('/root/main_scene/upgrade')

func _process(_delta):	
	var fully_resolved = true

	if phase in ['prepare_round', 'resolving_enemy_turn', 'resolving_player_turn', 'player_play_card']:
		_debug.set_text('Plays', str(_remaining_plays))
		_debug.set_text('Target damage', str(_target_damage))
		_debug.set_text('Damage dealt', str(_dealt_damage))

	if phase not in ['prepare_upgrade_choice', 'prepare_round', 'resolving_enemy_turn', 'resolving_player_turn']:
		return;

	if _resolving_node == null:
		var highest_priority = -100

		for node in _main_scene.get_children_in_groups(_main_scene, [phase], true):
			if node not in _ignoring_triggers:
				highest_priority = max(highest_priority, node.priority)

		for node in _main_scene.get_children_in_groups(_main_scene, [phase], true):
			if (node.priority == highest_priority) and (node not in _ignoring_triggers):
				fully_resolved = false
				_resolving_node = node.get_parent()
				node.trigger(phase)
				return
		
		if fully_resolved:
			if phase == 'prepare_upgrade_choice':
				_let_player_choose_upgrade()
				return
			if phase == 'prepare_round':
				_resolve_enemy_turn()
				return
			if phase == 'resolving_enemy_turn':
				_let_player_play_card()
				return
			elif phase == 'resolving_player_turn':
				_clear_command()
				_resolve_enemy_turn()
				return

func set_up():
	_deck.generate_starting_deck()

func prepare_upgrade_choice():
	phase = 'prepare_upgrade_choice'
	_ignoring_triggers = []
	_resolving_node = null
	_upgrade.visible = true
	_round.visible = false

	_main_scene.set_colliders_enabled(_upgrade, true)
	_main_scene.set_colliders_enabled(_round, false)

func _let_player_choose_upgrade():
	phase = 'player_choose_upgrade'
	_ignoring_triggers = []
	_resolving_node = null

func prepare_round():
	phase = 'prepare_round'
	_ignoring_triggers = []
	_resolving_node = null
	_upgrade.visible = false
	_round.visible = true

	_main_scene.set_colliders_enabled(_upgrade, false)
	_main_scene.set_colliders_enabled(_round, true)

	for deck_card in _main_scene.get_children_in_groups(_deck, ['card']):
		var draw_pile_card = _copy.copy_card(deck_card)
		draw_pile_card.move_to_draw_pile()
		draw_pile_card.rotation_degrees = Vector3.ZERO
		draw_pile_card.position = Vector3.ZERO

	_main_scene.set_colliders_enabled(_round, true)
	_enemy_spawner.prepare_round()

func _resolve_enemy_turn():
	phase = 'resolving_enemy_turn'
	_ignoring_triggers = []
	_resolving_node = null

func _let_player_play_card():
	phase = 'player_play_card'
	_ignoring_triggers = []
	_resolving_node = null

func resolve_player_turn():
	if phase == 'player_play_card':
		_remaining_plays -= 1
		phase = 'resolving_player_turn'
		_ignoring_triggers = []
		_resolving_node = null

func _clear_command():
	for child in _control.get_children():
		child.queue_free()

func resolve_node(node, done, secs = 0.1):
	if secs > 0.0:
		await _main_scene.delay(secs)

	_resolving_node = null
	if done:
		var resolved_trigger_array = _main_scene.get_children_in_groups(node, [phase])
		if len(resolved_trigger_array) > 0:
			_ignoring_triggers.append(resolved_trigger_array[0])

func damage_dealt(damage):
	_dealt_damage += damage

func trigger(phase):
	if phase == 'prepare_round':
		if len(_hand.get_cards_in_hand()) < 5:
			var draw_card = _main_scene.get_children_in_groups(_draw_pile, ['card']).pick_random()
			draw_card.move_to_hand()
			resolve_node(self, false)
			return
		else:
			resolve_node(self, true)
			return
	
	
