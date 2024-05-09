extends Node3D

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

func prepare_round(current_round):
	_current_round = current_round
	_enemy_waves.set_round(_current_round)

func prepare_wave(current_wave):
	_current_wave = current_wave
	_spawn_order = _enemy_waves.get_spawn_order(_current_wave)
	_remaining_spawns = _enemy_waves.get_enemy_spawns_in_wave(_current_wave)

func _spawn_enemy():
	for spawn_pos in _spawn_order:
		var entity = _board.get_entity(spawn_pos.x, spawn_pos.y)
		if entity is Node:
			continue
		
		var tile = _board.get_tile(spawn_pos.x, spawn_pos.y)		
		if tile is Node:
			var enemy = _main_scene.instantiate(_remaining_spawns.pop_front())
			enemy.reparent(_entities)
			enemy.global_position = tile.global_position
			enemy.current_position = enemy.global_position
			return true
	
	return false

func trigger(phase):
	if phase == 'resolving_enemy_turn':
		if len(_remaining_spawns) > 0:
			if _spawn_enemy():
				_game_manager.resolve_node(self, false)
				return
		
		_game_manager.resolve_node(self, true)
		
