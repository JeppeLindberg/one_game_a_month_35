extends Node3D

var _board
var _game_manager
var _enemy_spawner

func _ready():
	_board = get_node('/root/main_scene/board')
	_game_manager = get_node('/root/main_scene/game_manager')
	_enemy_spawner = get_node('/root/main_scene/enemy_spawner')

func trigger(phase):
	if phase == 'resolving_enemy_turn':
		var resolved = true
		var found_enemy = false

		for y in range(4,-1,-1):
			for entity in _board.get_entities_in_row(y):
				if entity.is_in_group('enemy'):
					found_enemy = true
					resolved = false
					entity.move_forward()

			if found_enemy:
				_game_manager.resolve_node(self, false)
				return

		if resolved:
			_enemy_spawner.prepare_wave();
			_game_manager.resolve_node(self, true)
		


