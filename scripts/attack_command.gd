extends Node3D

var _main_scene
var _board
var _visual_effects

@export var _attack_highlight_prefab: PackedScene

var _hovering_tile = null;
var _attack_positions: Array

func _ready():
	_main_scene = get_node('/root/main_scene')
	_board = get_node('/root/main_scene/board')
	_visual_effects = get_node('/root/main_scene/board/visual_effects')

	for attack_marker in get_children():
		_attack_positions.append(attack_marker.position)
		attack_marker.queue_free()

func _process(_delta):
	_update_visual()

func _update_visual():
	for attack_highlight in _main_scene.get_children_in_groups(_visual_effects, ['attack_highlight']):
		attack_highlight.queue_free()
	
	if _hovering_tile != null:
		for pos in _attack_positions:
			var attack_highlight = _attack_highlight_prefab.instantiate()
			_visual_effects.add_child(attack_highlight)
			attack_highlight.global_position = _hovering_tile.global_position + pos
			attack_highlight.add_to_group('attack_highlight')

func _commit_attack():
	if _hovering_tile != null:
		for pos in _attack_positions:
			var entity = _board.get_entity_via_vec(_hovering_tile.global_position + pos)
			if entity is Node:
				entity.take_damage(1)

	_hovering_tile = null
	_update_visual()
	queue_free()

func mouse_move(event):
	_hovering_tile = null
	var node = _main_scene.get_collision(event.position, 'tile')
	if node is Node:
		_hovering_tile = node
	
	_update_visual()

func mouse_press(event):
	_hovering_tile = null
	var node = _main_scene.get_collision(event.position, 'tile')
	if node is Node:
		_hovering_tile = node

	_update_visual()

func mouse_release(_event):
	_commit_attack()
