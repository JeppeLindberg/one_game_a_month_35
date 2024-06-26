extends Node3D

var _camera: Camera3D
var _game_manager
var _copy

@export var card_up_curve: Curve
@export var card_horizontal_curve: Curve

var _result

func _ready():
	_camera = get_node('/root/main_scene/camera');
	_game_manager = get_node('/root/main_scene/game_manager');
	_copy = get_node('/root/main_scene/copy');
	
	_game_manager.set_up()
	_game_manager.prepare_upgrade_choice()

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

func set_colliders_enabled(node, enabled):
	if node is CollisionShape3D:
		node.disabled = not enabled

	for child in node.get_children():
		set_colliders_enabled(child, enabled)		

func delay(secs = 0.1):
	await get_tree().create_timer(secs).timeout

func seconds():
	return float(Time.get_ticks_msec()) / 1000.0

func instantiate(prefab, parent = self):
	var instance = prefab.instantiate()
	parent.add_child(instance)
	instance.position = Vector3.ZERO
	if instance.has_method("activate"):
		instance.activate()

	if instance.is_in_group('card'):
		_copy.add_card(instance, prefab)
	return instance

func get_enemy_info(enemy_prefab):
	var enemy = instantiate(enemy_prefab)
	var implementation = enemy.get_node('implementation')
	var power = implementation.health * implementation.threat
	enemy.queue_free()
	return {'power' : power}

func get_card_info(card_prefab):
	var card = instantiate(card_prefab)
	var implementation = card.get_node('implementation')
	var rarity = implementation.rarity
	card.queue_free()
	return {'rarity' : rarity}

func clear(node):
	if node.has_method('clear'):
		node.clear()
	
	for child in node.get_children():
		clear(child)
