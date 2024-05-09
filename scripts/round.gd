extends Node3D

var _main_scene
var _entities
var _visual_effects
var _draw_pile
var _hand
var _discard_pile

func _ready():
	_main_scene = get_node('/root/main_scene')
	_entities = get_node('/root/main_scene/round/board/entities')
	_visual_effects = get_node('/root/main_scene/round/board/visual_effects')
	_draw_pile = get_node('/root/main_scene/round/draw_pile')
	_hand = get_node('/root/main_scene/round/hand')
	_discard_pile = get_node('/root/main_scene/round/discard_pile')

func clear():
	for card in _draw_pile.get_children():
		card.queue_free()
	for card in _hand.get_children():
		card.queue_free()
	for card in _discard_pile.get_children():
		card.queue_free()
	for effect in _visual_effects.get_children():
		effect.queue_free()
	for entity in _entities.get_children():
		entity.queue_free()