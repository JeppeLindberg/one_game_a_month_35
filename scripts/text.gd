extends Node

var _text_mesh

@export var starting_text: String = 'bla'

func _ready():
	_text_mesh = get_node("mesh")
	set_text(starting_text)

func set_text(new_text):
	_text_mesh.mesh.text = new_text
