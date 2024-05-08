extends Node3D

var _main_scene

var prefabs = {}

func _ready():
	_main_scene = get_node('/root/main_scene')

func add_card(card, prefab):
	prefabs[card] = prefab

func copy_card(card):
	var new_card = _main_scene.instantiate(prefabs[card])
	# new_card.damage = card.damage
	# new_card.multiplier = card.multiplier
	return new_card
