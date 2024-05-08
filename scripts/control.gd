extends Node3D

var _main_scene
var _game_manager
var _camera: Camera3D

var _current_command: Node

func _ready():
	_main_scene = get_node('/root/main_scene')
	_game_manager = get_node('/root/main_scene/game_manager')
	_camera = get_node('/root/main_scene/camera')

func set_command(new_command):
	for child in _main_scene.get_children_in_groups(self, ['command']):
		child.queue_free()

	new_command.reparent(self)
	_current_command = new_command

func _unhandled_input(event):
	if _game_manager.phase == 'player_choose_upgrade':
		var upgrade_chosen = false

		if event is InputEventMouseButton:
			if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
				var card = _main_scene.get_collision(event.position, 'card')
				if card is Node:
					upgrade_chosen = true
					card.mouse_press();
		
		if upgrade_chosen:
			_game_manager.prepare_round()

	elif _game_manager.phase == 'player_play_card':
		if event is InputEventMouseMotion:
			if (_current_command != null) and (not _current_command.is_queued_for_deletion()):
				_current_command.mouse_move(event);
		if event is InputEventMouseButton:
			if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed):
				if (_current_command == null) or (_current_command.is_queued_for_deletion()):
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

