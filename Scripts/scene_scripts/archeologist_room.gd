extends Room

const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")

@onready var _ui = $UILayer/CharacterRoomUI

func _ready() -> void:
	_setup_character_menu(_ui.get_options_menu())
	# Must call _ui.set_character() with the character object as parameter to
	# change the ui button's sprites

func _setup_character_menu(menu: OptionsMenu):
	menu.add_option("William")
	menu.add_option("Scars")
	menu.add_option("Leave")
	
	menu.get_option_button("William").pressed.connect(_william_dialogue)
	menu.get_option_button("Scars").pressed.connect(_scars_dialogue)
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

func _william_dialogue() -> void:
	var dia = _dialogue_setup()
	var lines = [
		"He’s a hard working guy, had very few conversations with him.",
		"The few I had were about movies, he seems to really like those.",
		"And noticed his attention to detail, especially with sounds",
		"Once I opened my door and in the same second that a bolt is almost falling, and it truly was",
		"That really looks like super powers."
	]
	
	dia.start_dialogue_animation.emit()

	for text in lines:
		dia.send_dia.emit(text)
		await dia.dialogue_finish
		await dia.pressed_enter
	
	dia.queue_free()
	$UILayer.show()

func _scars_dialogue() -> void:
	var dia = _dialogue_setup()
	var lines = [
		"These are result of an accident I had many years ago.",
		"A reminder of my past…",
		"And noticed his attention to detail, especially with sounds",
		"I was so close but so far… And now I have these",
		"One of life´s jokes."
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
	
	dia.send_dia.emit("You’re the boss, come whenever needed.")
	await dia.dialogue_finish
	await dia.pressed_enter
	
	dia.queue_free()
	#navigator.go_to_room("corridor")
