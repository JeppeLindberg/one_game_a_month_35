extends Node3D

var _tilemap
var _entities

func _ready():
	_tilemap = get_node('tilemap')
	_entities = get_node('entities')

func get_tile(x, y):
	for child in _tilemap.get_children():
		if child.position == Vector3(x, 0, y):
			return child
	
	return null

func get_entity_via_vec(vec):
	return get_entity(round(vec.x), round(vec.z))

func get_entity(x, y):
	for child in _entities.get_children():
		if child.current_position == Vector3(x, 0, y):
			return child
	
	return null

func get_entities_in_row(y):
	var entities = []
	for child in _entities.get_children():
		if child.current_position.z == y:
			entities.append(child)
	
	return entities

