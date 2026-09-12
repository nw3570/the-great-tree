extends Room

const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")

@onready var _ui = $UILayer/CharacterRoomUI

func _ready() -> void:
	_setup_character_menu(_ui.get_options_menu())
	# Must call _ui.set_character() with the character object as parameter to
	# change the ui button's sprites

func _setup_character_menu(menu: OptionsMenu):
	menu.add_option("Dolores")
	menu.get_option_button("Dolores").pressed.connect(_dolores_dialogue)
	menu.add_option("Ex-husband")
	menu.get_option_button("Ex-husband").pressed.connect(_ex_husband_dialogue)
	
	# If the player has seen the "Shift" dialogue from the busines guy, add
	# an option for _williams_movie_dialogue.
	if true:
		menu.add_option("Wlliam's movie")
		menu.get_option_button("Wlliam's movie").pressed.connect(_williams_movie_dialogue)
	
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

func _dolores_dialogue() -> void:
	var dia = _dialogue_setup()
	var lines = [
		"That old lady? She is losing her marble.",
		"She once knocked on my door just to go away the moment I opened it.",
		"She just annoys the residents, but if I say something I’m \"rude\".",
		"I just say what I think."
	]
	
	dia.start_dialogue_animation.emit()

	for text in lines:
		dia.send_dia.emit(text)
		await dia.dialogue_finish
		await dia.pressed_enter
	
	dia.queue_free()
	$UILayer.show()

func _ex_husband_dialogue() -> void:
	var dia = _dialogue_setup()
	var lines = [
		"He is the devil, the worst I’ve ever met. Despicable.",
		"He always manipulated me to think I was wrong when I complained with the brats on the other side of the street and many other fights other people made me do.",
		"Then, out of nowhere, he came with the papers. Without thinking about the kids, how all this would impact them. Disgusting."
	]
	
	dia.start_dialogue_animation.emit()

	for text in lines:
		dia.send_dia.emit(text)
		await dia.dialogue_finish
		await dia.pressed_enter
	
	dia.queue_free()
	$UILayer.show()

func _williams_movie_dialogue() -> void:
	var dia = _dialogue_setup()
	var lines = [
		"Oh yes, he watched a movie the other day. I think it couldn’t get much louder.",
		"Still I don’t think it was loud enough to not hear me almost break the door."
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
	
	dia.send_dia.emit("It took you long enough. Knock if you want something again.")
	await dia.dialogue_finish
	await dia.pressed_enter
	
	dia.queue_free()
	#navigator.go_to_room("corridor")
