extends Node3D

@export var _enemy_prefab: PackedScene

var _main_scene
var _game_manager
var _board
var _entities
var _enemy_waves

var _spawn_order
var _remaining_spawns

var _current_round = 0
var _current_wave = 0

func _ready():
	_main_scene = get_node('/root/main_scene')
	_game_manager = get_node('/root/main_scene/game_manager')
	_enemy_waves = get_node('/root/main_scene/round/enemy_waves')
	_board = get_node('/root/main_scene/round/board')
	_entities = get_node('/root/main_scene/round/board/entities')

func prepare_round():
	_current_round += 1
	_enemy_waves.set_round(_current_round)

func prepare_wave():
	_current_wave += 1
	_spawn_order = _enemy_waves.get_spawn_order(_current_wave)
	_remaining_spawns = _enemy_waves.get_enemies(_current_wave)

func _spawn_enemy():
	_remaining_spawns -= 1

	for spawn_pos in _spawn_order:
		var entity = _board.get_entity(spawn_pos.x, spawn_pos.y)
		if entity is Node:
			continue
		
		var tile = _board.get_tile(spawn_pos.x, spawn_pos.y)		
		if tile is Node:
			var enemy = _main_scene.instantiate(_enemy_prefab)
			enemy.reparent(_entities)
			enemy.global_position = tile.global_position
			enemy.current_position = enemy.global_position
			return true
	
	return false

func trigger(phase):
	if phase == 'resolving_enemy_turn':
		if _remaining_spawns > 0:
			if _spawn_enemy():
				_game_manager.resolve_node(self, false)
				return
		
		_game_manager.resolve_node(self, true)
		
