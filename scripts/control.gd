extends Node3D

var _main_scene
var _camera: Camera3D

func _ready():
	_main_scene = get_node('/root/main_scene')
	_camera = get_node('/root/main_scene/camera')

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			var node = _main_scene.get_collision(event.position, 'tile')
			if node is Node:
				print('test');

