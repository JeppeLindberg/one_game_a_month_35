extends Node3D

@export var _enemy_prefab: PackedScene

var _main_scene
var _game_manager
var _board
var _entities
var _enemy_waves

var _spawn_order

func _ready():
	_main_scene = get_node('/root/main_scene')
	_game_manager = get_node('/root/main_scene/game_manager')
	_enemy_waves = get_node('/root/main_scene/enemy_waves')
	_board = get_node('/root/main_scene/board')
	_entities = _board.get_node('entities')

func prepare_wave():
	_spawn_order = _enemy_waves.get_spawn_order()

func trigger(phase):
	if phase == 'resolving_enemy_turn':
		var spawn_pos = _spawn_order.pop_front()
		var tile = _board.get_tile(spawn_pos.x, spawn_pos.y)
		if tile is Node:
			var enemy = _enemy_prefab.instantiate()
			_entities.add_child(enemy)
			enemy.global_position = tile.global_position
			enemy.current_position = enemy.global_position
		
		if _spawn_order.is_empty():
			_game_manager.resolve_node(self, true)
		else:
			_game_manager.resolve_node(self, false)
		
