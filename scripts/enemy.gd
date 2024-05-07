extends Node3D

var _game_manager

var _health_text

@export var health = 5

var current_position

func _ready():
	add_to_group('enemy')
	_game_manager = get_node('/root/main_scene/game_manager')
	_health_text = get_node('health_text')
	_update_health_text()
	current_position = global_position

func _process(_delta):
	global_position = lerp(global_position, current_position, 0.2)

func take_damage(damage):
	health -= damage
	_update_health_text()
	_game_manager.damage_dealt(damage)

func _update_health_text():
	_health_text.set_text(str(health))

func move_forward():
	current_position += Vector3.BACK
