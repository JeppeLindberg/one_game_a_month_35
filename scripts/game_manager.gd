extends Node3D

var _main_scene
var _debug
var _enemy_spawner
var _board
var _entities
var _hand
var _draw_pile
var _control

var _phase = 'none'
var _ignoring_triggers = []
var _resolving_node = null

var _remaining_plays = 8
var _target_damage = 100
var _dealt_damage = 0

func _ready():
	_main_scene = get_node('/root/main_scene')
	_board = get_node('/root/main_scene/board')
	_hand = get_node('/root/main_scene/hand')
	_draw_pile = get_node('/root/main_scene/draw_pile')
	_control = get_node('/root/main_scene/control')
	_enemy_spawner = get_node('/root/main_scene/enemy_spawner')
	_debug = get_node('/root/main_scene/debug')
	_entities = _board.get_node('entities')

func _process(_delta):
	_debug.set_text('Plays', str(_remaining_plays))
	_debug.set_text('Target damage', str(_target_damage))
	_debug.set_text('Damage dealt', str(_dealt_damage))
	
	if _phase == 'player_play_card':
		return

	if _resolving_node == null:
		var fully_resolved = true
		var highest_priority = -100

		for node in _main_scene.get_children_in_groups(_main_scene, [_phase], true):
			if node not in _ignoring_triggers:
				highest_priority = max(highest_priority, node.priority)

		for node in _main_scene.get_children_in_groups(_main_scene, [_phase], true):
			if (node.priority == highest_priority) and (node not in _ignoring_triggers):
				fully_resolved = false
				_resolving_node = node.get_parent()
				node.trigger(_phase)
				return
	
		if fully_resolved:
			if _phase == 'setting_up':
				_resolve_enemy_turn()
				return
			if _phase == 'resolving_enemy_turn':
				_let_player_play_card()
				return
			elif _phase == 'resolving_player_turn':
				_clear_command()
				_resolve_enemy_turn()
				return

func set_up():
	_phase = 'setting_up'
	_ignoring_triggers = []
	_resolving_node = null
	_enemy_spawner.prepare_round()

func _resolve_enemy_turn():
	_phase = 'resolving_enemy_turn'
	_ignoring_triggers = []
	_resolving_node = null

func _let_player_play_card():
	_phase = 'player_play_card'
	_ignoring_triggers = []
	_resolving_node = null

func resolve_player_turn():
	if _phase == 'player_play_card':
		_remaining_plays -= 1
		_phase = 'resolving_player_turn'
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
		var resolved_trigger_array = _main_scene.get_children_in_groups(node, [_phase])
		if len(resolved_trigger_array) > 0:
			_ignoring_triggers.append(resolved_trigger_array[0])

func damage_dealt(damage):
	_dealt_damage += damage

func trigger(phase):
	if phase == 'setting_up':
		if len(_hand.get_cards_in_hand()) < 5:
			var draw_card = _main_scene.get_children_in_groups(_draw_pile, ['card']).pick_random()
			draw_card.move_to_hand()
			resolve_node(self, false)
			return
		else:
			resolve_node(self, true)
			return
	
	
