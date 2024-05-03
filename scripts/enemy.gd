extends Node3D

var _health_text

@export var health = 5

func _ready():
	_health_text = get_node('health_text')
	_update_health_text()

func take_damage(damage):
	health -= damage
	_update_health_text()

func _update_health_text():
	_health_text.set_text(str(health))

