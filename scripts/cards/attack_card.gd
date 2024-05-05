extends StaticBody3D

var _control
var _main_scene
var _discard_pile
var _draw_pile
var _hand

@export var _name: String
@export var _command_prefab: PackedScene
@export var _damage: int = 5
@export var _multiplier: int = 1

var _attack_pattern
var _name_text
var _damage_text
var _full_view
var _small_view

var _allow_full_view = false
var _allow_small_view = true

var _origin_position
var _target_position
var _target_distance
var _uncurved_position
var _move_toward_position

func _ready():
	add_to_group('card')
	_control = get_node('/root/main_scene/control')
	_main_scene = get_node('/root/main_scene')
	_discard_pile = get_node('/root/main_scene/discard_pile')
	_draw_pile = get_node('/root/main_scene/draw_pile')
	_hand = get_node('/root/main_scene/hand')
	_attack_pattern = get_node('full_view/attack_pattern')
	_name_text = get_node('full_view/name_text')
	_damage_text = get_node('full_view/damage_text')
	_full_view = get_node('full_view')
	_small_view = get_node('small_view')

	_target_position = global_position
	_uncurved_position = global_position
	_move_toward_position = global_position
	
	_update_visual()

func _process(delta):
	if _move_toward_position != _target_position:
		var distance = _uncurved_position.distance_to(_target_position)
		var uncurved_ratio = delta / distance * sqrt(_target_distance) * 5
		var ratio = clamp(0, 1, uncurved_ratio * _main_scene.card_horizontal_curve.sample(uncurved_ratio))
		_uncurved_position = lerp(_uncurved_position, _target_position, ratio)
		distance = _uncurved_position.distance_to(_target_position)
		var progress = inverse_lerp(0, _target_distance, distance)
		var use_up_curve = _origin_position.distance_to(_target_position) > 1
		if use_up_curve:
			_move_toward_position = _uncurved_position + Vector3.UP * _main_scene.card_up_curve.sample(progress) * (_target_distance * 0.5)
		else:
			_move_toward_position = _uncurved_position

	global_position = lerp(global_position, _move_toward_position, 0.1)

	_update_visual()

func _update_visual():
	_name_text.set_text(_name)	
	_damage_text.set_text(str(_damage) + ' x ' + str(_multiplier))

	var remaning_distance = global_position.distance_to(_target_position)
	if (remaning_distance < 1) and (_allow_full_view):
		_full_view.visible = true
		_small_view.visible = false
	elif remaning_distance < 0.1:
		_full_view.visible = _allow_full_view
		_small_view.visible = false
	else:
		_full_view.visible = false
		_small_view.visible = _allow_small_view

func mouse_press():
	var command = _command_prefab.instantiate()
	command.card_source = self
	command.damage = _damage
	command.multiplier = _multiplier

	command.attack_positions = []
	
	for attack_marker in _attack_pattern.get_children():
		command.attack_positions.append(attack_marker.position)

	_control.set_command(command)

func move_to_hand():
	_hand.add(self)
	_hand.align_cards()
	_allow_full_view = true
	_allow_small_view = true
	
	_update_visual()

func move_to_discard_pile():
	_discard_pile.add(self)
	_hand.align_cards()
	_allow_full_view = false
	_allow_small_view = true
	
	_update_visual()

func move_to_draw_pile():
	_draw_pile.add(self)
	_allow_full_view = false
	_allow_small_view = true
	
	_update_visual()

func set_target_position(pos):
	if _move_toward_position == _target_position:
		_origin_position = global_position
		_uncurved_position = global_position
		_move_toward_position = global_position
		_target_position = pos
		_target_distance = _origin_position.distance_to(_target_position)
	else:
		_target_position = pos


