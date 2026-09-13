extends Room
class_name CharacterRoom

const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")

@export var character_scene: PackedScene

@onready var _ui = $UILayer/CharacterRoomUI

func _ready() -> void:
	var temp_char = _character_instance()
	_setup_character_menu(_ui.get_options_menu())
	_ui.set_character(temp_char)
	temp_char.queue_free()

## Use it to set the options for the menu.
func _setup_character_menu(_menu: OptionsMenu):
	pass

func _character_instance() -> CHARACTER:
	var i = character_scene.instantiate() as CHARACTER
	return i

func _character_setup_for_dialogue(dia: dialogue_scene, cvisible: bool = true, speak: bool = true):
	var character = _character_instance()
	dia.add_child(character)
	character.add_to_group("character")
	
	dia.add_character.emit(cvisible)
	character.set_speak.emit(speak)

## Creates and sets up a new dialogue scene to use.
func _dialogue_setup() -> dialogue_scene:
	var dia = DIALOGUE_SCENE.instantiate() as dialogue_scene
	dia.z_index += 5
	#dia.ui = $UILayer
	add_child(dia)
	$UILayer.hide()
	
	return dia

## Use after a dalogue is over to show the ui again and get rid of the used
## dialogue scene
func _dialogue_end(dia: dialogue_scene):
	dia.queue_free()
	$UILayer.show()

## Adds an option to the room that when clicked will change the room to the
## given destination room.
func _add_leave_option(destinaton_room_id: String, label: String = "Leave"):
	var menu: OptionsMenu = _ui.get_options_menu()
	
	menu.add_option(label)
	menu.get_option_button(label).pressed.connect(_leave.bind(destinaton_room_id))

func _leave(destinaton_room_id: String):
	var dia = _dialogue_setup()
	_character_setup_for_dialogue(dia)
	_leave_dialogue(dia)
	_dialogue_end(dia)
	
	navigator.go_to_room(destinaton_room_id)

## Use it to write a dialogue for before the player leaves the room, if you used
## _add_leave_option. The dialogue should not be discarded of in this funtion,
## as it is handled later on.
func _leave_dialogue(_dia: dialogue_scene) -> void:
	pass
