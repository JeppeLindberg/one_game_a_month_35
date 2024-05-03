extends Node3D

var _camera: Camera3D

func _ready():
	_camera = get_node('/root/main_scene/camera');

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


