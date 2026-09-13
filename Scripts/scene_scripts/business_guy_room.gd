extends Room

const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")

@onready var _ui = $UILayer/CharacterRoomUI

func _ready() -> void:
	_setup_character_menu(_ui.get_options_menu())
	# Must call _ui.set_character() with the character object as parameter to
	# change the ui button's sprites

func _setup_character_menu(menu: OptionsMenu):
	menu.add_option("Movies")
	menu.get_option_button("Movies").pressed.connect(_movies_dialogue)
	menu.add_option("Karen")
	menu.get_option_button("Karen").pressed.connect(_karen_dialogue)
	
	# If the character is the culprit, check if the computer interaction has
	# happened. It can be stored with other game flags in some data structure.
	# If the player has already interacted with the computer before, add the 
	# shift dialogue. Otherwise, connect the computer's object to a method that
	# sets the flag for the computer interaction in the game state and also
	# calls add_shift_dialogue inside of it.
	# That way, when the player change rooms, the option will be present. And it
	# will also be present right after the player has interacted with the computer
	if culprit == Gameplay.CulpritCharacter.WILLIAM:
		if game_flags.has("saw_william_culprit_email") && game_flags["saw_william_culprit_email"]:
			add_shift_dialogue()
		else:
			# _computer.mouse_clicked.connect(_on_computer_interacted)
			pass
	
	menu.add_option("Leave")
	menu.get_option_button("Leave").pressed.connect(_leave_dialogue)

func add_shift_dialogue() -> void:
	var menu: OptionsMenu = _ui.get_options_menu()
	
	menu.add_option("Shift")
	menu.get_option_button("Shift").pressed.connect(_shift_dialogue)

func _on_computer_interacted() -> void:
	game_flags["saw_william_culprit_email"] = true
	add_shift_dialogue()

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

func _movies_dialogue() -> void:
	var dia = _dialogue_setup()
	var lines = [
		"I really love watching some movies in my few hours of free time.",
		"I know I don’t have many, but if I bought new ones I wouldn’t want to waste my time on those",
		"I already know that these are my favourites of all time.",
		"And the money factor also doesn't help."
	]
	
	dia.start_dialogue_animation.emit()
	
	for text in lines:
		dia.send_dia.emit(text)
		await dia.dialogue_finish
		await dia.pressed_enter
	
	dia.queue_free()
	$UILayer.show()

func _karen_dialogue() -> void:
	var dia = _dialogue_setup()
	var lines = [
		"She doesn’t seem pretty happy, unlike me she’s always angry.",
		"She complains with the younger neighbours, on the phone, with everything honestly.",
		"When I arrived here for the first time she tried to be polite, but I felt how empty her words and smile were."
	]
	
	dia.start_dialogue_animation.emit()
	
	for text in lines:
		dia.send_dia.emit(text)
		await dia.dialogue_finish
		await dia.pressed_enter
	
	dia.queue_free()
	$UILayer.show()

func _shift_dialogue():
	var dia = _dialogue_setup()
	var lines = [
		"Oh, I think I can relax after working non stop for so much time.",
		"I used that time to rewatch my favourite movie, I watched it was quite loud, maybe Karen heard it.",
		"I just wanted to relax for once."
	]
	
	dia.start_dialogue_animation.emit()
	for text in lines:
		dia.send_dia.emit(text)
		await dia.dialogue_finish
		await dia.pressed_enter
	
	dia.queue_free()
	$UILayer.show()
	
	# Set flag that the player saw this dialogue, for the condition in the
	# divorced's room. See "divorced_room.gd"
	game_flags["saw_william_shift_dialogue"] = true

func _leave_dialogue() -> void:
	var dia = _dialogue_setup()
	
	dia.send_dia.emit("Ok, hope you don’t need anything else from me. I’ll be here any way.")
	await dia.dialogue_finish
	await dia.pressed_enter
	
	dia.queue_free()
	navigator.go_to_room("corridor")
