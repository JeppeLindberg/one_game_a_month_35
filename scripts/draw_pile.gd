extends Node3D


func add(card):
	card.reparent(self)
	card.set_target_position(global_position)
