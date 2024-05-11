extends Node3D

var _game_manager
var _main_scene
var _upgrade_choice

@export var card_prefabs: Array[PackedScene]

var _base_chance = {'basic': 0.0, 'common': 7.0, 'rare': 0.0, 'exalted': 0.0, 'unavailable': 0.0}
var _card_rarity_index = []
var _remaining_upgrade_choices = 3

func _ready():
	_main_scene = get_node('/root/main_scene')
	_game_manager = get_node('/root/main_scene/game_manager')
	_upgrade_choice = get_node('/root/main_scene/upgrade/upgrade_choice')

func generate_upgrade_choice():
	if len(_card_rarity_index) == 0:
		for i in range(len(card_prefabs)):
			_card_rarity_index.append([_main_scene.get_card_info(card_prefabs[i])['rarity'], i])

	var rarity_top = 0.0
	for value in _base_chance.values():
		rarity_top += value
	
	var rarity_ratio = randf() * rarity_top

	var resulting_rarity = ''
	for rarity in _base_chance.keys():
		rarity_ratio -= _base_chance[rarity]
		if rarity_ratio <= 0:
			resulting_rarity = rarity
			break
	
	var total_cards_of_rarity = 0
	for rarity_index in _card_rarity_index:
		if rarity_index[0] == resulting_rarity:
			total_cards_of_rarity += 1
	
	var card_index = randi() % total_cards_of_rarity + 1
	var resulting_card_index = -1
	for rarity_index in _card_rarity_index:
		if rarity_index[0] == resulting_rarity:
			card_index -= 1
			if card_index <= 0:
				resulting_card_index = rarity_index[1]
				break

	var card = _main_scene.instantiate(card_prefabs[resulting_card_index])
	card.move_to_upgrade_choice()

func clear():
	for child in _upgrade_choice.get_children():
		child.queue_free()
	_remaining_upgrade_choices = 3

func trigger(phase):
	if phase == 'prepare_upgrade_choice':
		if _remaining_upgrade_choices > 0:
			generate_upgrade_choice()
			_remaining_upgrade_choices -= 1			
			_game_manager.resolve_node(self, false)
			return
		else:
			_game_manager.resolve_node(self, true)
			return
		

