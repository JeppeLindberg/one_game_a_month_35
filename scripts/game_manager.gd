extends Node3D

@export var _enemy_prefab: PackedScene

var _board
var _tilemap
var _entities

func _ready():
	_board = get_node('/root/main_scene/board')
	_entities = _board.get_node('entities')
	_tilemap = _board.get_node('tilemap')

func go_to_next_battle():
	var tiles = [_board.get_tile(1, 2), _board.get_tile(3, 3)]

	for tile in tiles:
		if tile is Node:
			var enemy = _enemy_prefab.instantiate()
			_entities.add_child(enemy)
			enemy.global_position = tile.global_position
