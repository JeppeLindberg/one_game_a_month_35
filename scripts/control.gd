extends Node3D

var _main_scene
var _camera: Camera3D

var _current_command: Node

func _ready():
	_main_scene = get_node('/root/main_scene')
	_camera = get_node('/root/main_scene/camera')

func set_command(new_command):
	for child in _main_scene.get_children_in_groups(self, ['command']):
		child.queue_free()

	add_child(new_command)
	_current_command = new_command

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if (_current_command != null) and (not _current_command.is_queued_for_deletion()):
			_current_command.mouse_move(event);
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed):
			var bell = _main_scene.get_collision(event.position, 'bell')
			if bell is Node:
				bell.mouse_press();

			var card = _main_scene.get_collision(event.position, 'card')
			if card is Node:
				card.mouse_press();
				
			if (_current_command != null) and (not _current_command.is_queued_for_deletion()):
				_current_command.mouse_press(event);

		if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			if (_current_command != null) and (not _current_command.is_queued_for_deletion()):
				_current_command.mouse_release(event);

