extends Node3D

var _main_scene

@export var _card_distance: float = 1.1

func _ready():
	add_to_group('upgrade_choice')
	_main_scene = get_node('/root/main_scene')
	align_cards()

func add(card):
	card.reparent(self)
	align_cards()

func align_cards():
	var cards = _main_scene.get_children_in_groups(self, ['card'])
	var card_count = len(cards)
	for i in range(card_count):
		var origin = global_position
		var pos_modifier_per_card = Vector3.RIGHT * _card_distance

		cards[i].rotation_degrees = Vector3.ZERO
		cards[i].global_position = origin + pos_modifier_per_card * i
		cards[i].set_target_position(origin + pos_modifier_per_card * i)