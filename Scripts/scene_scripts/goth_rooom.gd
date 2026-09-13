extends Room

const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")

@onready var _ui = $UILayer/CharacterRoomUI

func _ready() -> void:
	_setup_character_menu(_ui.get_options_menu())
	# Must call _ui.set_character() with the character object as parameter to
	# change the ui button's sprites. Or find another way to pass the textures
	# to the function

func _setup_character_menu(menu: OptionsMenu):
	menu.add_option("Leave")
	menu.get_option_button("Leave").pressed.connect(_leave_dialogue)

func _spawn_character() -> void:
	pass

func _dialogue_setup() -> dialogue_scene:
	var dia = DIALOGUE_SCENE.instantiate() as dialogue_scene
	dia.z_index += 5
	#dia.ui = $UILayer
	add_child(dia)
	
	#_spawn_character(dia)
	$UILayer.hide()
	
	return dia

func __dialogue() -> void:
	var dia = _dialogue_setup()
	var lines = [
		""
	]
	
	dia.start_dialogue_animation.emit()

	for text in lines:
		dia.send_dia.emit(text)
		await dia.dialogue_finish
		await dia.pressed_enter
	
	dia.queue_free()
	$UILayer.show()

func _leave_dialogue() -> void:
	var dia = _dialogue_setup()
	
	dia.send_dia.emit(".")
	await dia.dialogue_finish
	await dia.pressed_enter
	
	dia.queue_free()
	navigator.go_to_room("corridor")
