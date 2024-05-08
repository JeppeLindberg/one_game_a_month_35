extends Node3D

var _main_scene
var _board
var _visual_effects
var _game_manager

@export var _attack_highlight_prefab: PackedScene

var card_source: Node
var attack_positions: Array

var damage = 5
var multiplier = 1

var _card_discarded = false;
var _locked_attack = false;
var _hovering_tile = null;


func _ready():
	add_to_group('command')
	_main_scene = get_node('/root/main_scene')
	_board = get_node('/root/main_scene/round/board')
	_visual_effects = get_node('/root/main_scene/round/board/visual_effects')
	_game_manager = get_node('/root/main_scene/game_manager')

func _process(_delta):
	_update_visual()

func _update_visual():
	for attack_highlight in _main_scene.get_children_in_groups(_visual_effects, ['attack_highlight']):
		attack_highlight.queue_free()
	
	if (_hovering_tile != null) and (not _locked_attack):
		for pos in attack_positions:
			var attack_highlight = _attack_highlight_prefab.instantiate()
			_visual_effects.add_child(attack_highlight)
			attack_highlight.global_position = _hovering_tile.global_position + pos
			attack_highlight.add_to_group('attack_highlight')

func _commit_attack():
	_locked_attack = true
	_game_manager.resolve_player_turn();
	_update_visual()

func mouse_move(event):
	if _locked_attack:
		return

	_hovering_tile = null
	var node = _main_scene.get_collision(event.position, 'tile')
	if node is Node:
		_hovering_tile = node
	
	_update_visual()

func mouse_press(event):
	if _locked_attack:
		return
	
	_hovering_tile = null
	var node = _main_scene.get_collision(event.position, 'tile')
	if node is Node:
		_hovering_tile = node

	_update_visual()

func mouse_release(_event):
	if _hovering_tile != null:
		_commit_attack()
	else:
		queue_free()

func trigger(phase):
	if phase == 'resolving_player_turn':
		if not _card_discarded:
			card_source.move_to_discard_pile()

		if multiplier == 0:
			_game_manager.resolve_node(self, true)
			return
		else:
			for pos in attack_positions:
				var entity = _board.get_entity_via_vec(_hovering_tile.global_position + pos)
				if entity is Node:
					entity.take_damage(damage)
					
			multiplier -= 1
			_game_manager.resolve_node(self, false)

