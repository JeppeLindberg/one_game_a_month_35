extends Node3D

var _camera: Camera3D
var _game_manager

var _result

func _ready():
	_camera = get_node('/root/main_scene/camera');
	_game_manager = get_node('/root/main_scene/game_manager');
	_game_manager.go_to_next_battle()

# Get all children of the node that belongs to all of the given groups
func get_children_in_groups(node, groups, recursive = false):
	_result = []

	if recursive:
		_get_children_in_groups_recursive(node, groups)
		return _result

	for child in node.get_children():
		for group in groups:				
			if child.is_in_group(group):
				_result.append(child)
				break

	return _result

# Get all children of the node that belongs to all of the given groups
func _get_children_in_groups_recursive(node, groups):
	for child in node.get_children():
		var add_to_result = true;
		for group in groups:
			if not child.is_in_group(group):
				add_to_result = false;
				break
				
		if add_to_result:
			_result.append(child)

		_get_children_in_groups_recursive(child, groups)

func get_collision(screen_pos, group):
	var ray_from = _camera.project_ray_origin(screen_pos)
	var ray_to = ray_from + _camera.project_ray_normal(screen_pos) * 100
	var space_state = get_world_3d().direct_space_state
	var ray = PhysicsRayQueryParameters3D.new()
	ray.from = ray_from
	ray.to = ray_to
	var collision = space_state.intersect_ray(ray)

	var node = collision['collider']
	if node.is_in_group(group):
		return node

	return false


