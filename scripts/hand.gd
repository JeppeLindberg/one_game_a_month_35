extends Node3D

var _main_scene

@export var _card_distance: float = 1.1

func _ready():
	_main_scene = get_node('/root/main_scene')

func add(card):
	card.reparent(self)
	align_cards()

func get_cards_in_hand():
	return _main_scene.get_children_in_groups(self, ['card'])

func align_cards():
	var cards = _main_scene.get_children_in_groups(self, ['card'])
	var card_count = len(cards)
	for i in range(card_count):
		var origin = global_position + (Vector3.RIGHT * (card_count - 1) * _card_distance / 2)
		var pos_modifier_per_card = Vector3.LEFT * _card_distance

		cards[i].set_target_position(origin + pos_modifier_per_card * i)

