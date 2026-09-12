extends Control
class_name CharacterRoomUI

@export var leave_room_label: String = "Leave"

@onready var _options_menu = $OptionsMenu
@onready var _character_button = $TextureButton

var _anim_tween: Tween = null

func _ready() -> void:
	_character_button.toggled.connect(_on_character_button_toggled)
	_character_button.pivot_offset = _character_button.size / 2.0

#func _gui_input(event: InputEvent) -> void:
	#if event is not InputEventMouseButton || !event.is_action_pressed("LMB"):
		#return
	#
	#_options_menu.close()

func _on_character_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_start_character_button_amim()
	else:
		_stop_character_button_anim()
	
	_options_menu.toggle()

func _start_character_button_amim() -> void:
	if _anim_tween != null && _anim_tween.is_valid():
		return
	
	_anim_tween = create_tween()
	_anim_tween.set_loops()
	
	_anim_tween.tween_property(
		_character_button, "rotation",
		 deg_to_rad(15), 0.5
	)
	_anim_tween.tween_property(
		_character_button, "rotation",
		deg_to_rad(-15), 0.5
	)

func _stop_character_button_anim():
	if _anim_tween && _anim_tween.is_valid():
		_anim_tween.kill()
	
	_anim_tween = create_tween()
	_anim_tween.tween_property(_character_button, "rotation", 0.0, 0.5)
	await _anim_tween.finished

func set_character(character: CHARACTER) -> void:
	var frames = character.sprite.sprite_frames
	
	_character_button.texture_normal = frames.get_frame_texture("default", 2)
	_character_button.texture_pressed = frames.get_frame_texture("default", 3)

func get_options_menu() -> OptionsMenu:
	return _options_menu

func add_dialogue_option(label: String) -> void:
	_options_menu.add_option(label, _character_button.texture_normal)

func add_leave_room_option(navigator: RoomNavigator) -> void:
	_options_menu.add_option(leave_room_label)
	
	var btn_leave = _options_menu.get_option_button(leave_room_label)
	btn_leave.pressed.connect(navigator.go_back)
