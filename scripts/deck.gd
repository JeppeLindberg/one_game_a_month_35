extends Node3D

var _main_scene

@export var starting_deck_prefabs: Array[PackedScene]

func _ready():
	_main_scene = get_node('/root/main_scene')

func generate_starting_deck():
	for prefab in starting_deck_prefabs:
		var card = _main_scene.instantiate(prefab)
		card.move_to_deck()
		card.position = Vector3.ZERO
		card.rotation_degrees = Vector3.ZERO

func add(card):
	card.reparent(self)
	card.set_target_position(global_position)
