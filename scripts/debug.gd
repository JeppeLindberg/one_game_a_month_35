extends Node3D

@export var _debug_text_prefab: PackedScene

var texts = {}


func set_text(key, text):
	texts[key] = key + ": " + text

func _process(_delta):
	for child in get_children():
		child.queue_free()

	var position_modify = Vector3(0, 0, 0)
	
	for key in texts:
		var text = _debug_text_prefab.instantiate()
		text.set_text(texts[key])
		add_child(text)
		text.position = position_modify
		position_modify += Vector3.BACK * 0.3
	
	texts.clear()


