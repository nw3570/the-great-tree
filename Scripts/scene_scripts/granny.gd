extends Room
const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")
const OLD = preload("uid://4rdyi8de470a")

signal enter_pressed

var disease_dias = ["Oh yes… I have something in my head.",
"I forget some details here and there or act a bit out of the ordinary.",
"But don’t worry about that, I can still cook you a pie for you.",
"I believe that with The Tree of All Being nearby it will go away soon."
]
var family_dias = ["Of course I have a lovely family.",
"I had my handsome Henry, he died around seven years ago.",
"I also have two beautiful boys… They haven’t seen me for a long time, but I think they are preparing their houses so I can stay with them permanently.",
"I just have to be patient",]
@onready var _ui: CharacterRoomUI = $UILayer/CharacterRoomUI
var sharon_dias = ["Oh that poor little girl…",
"She has some beautiful eyes and could smile more.",
"But she is always with paint all over her face… and with evil symbols.",
"I truly feel something bad every time I see that poor soul",
]
func _ready() -> void:
	#_ui.add_leave_room_option(navigator)
	
	# Connect options_menu buttons to dialogues/interactions.
	var options_menu := _ui.get_options_menu()
	options_menu.add_option("Sharon")
	options_menu.add_option("Family")
	options_menu.add_option("Disease")
	options_menu.add_option("Leave")
	options_menu.get_option_button("Sharon").pressed.connect(_sharon_dialogue)
	options_menu.get_option_button("Family").pressed.connect(_family_dialogue)
	options_menu.get_option_button("Disease").pressed.connect(_disease_dialogue)
	options_menu.get_option_button("Leave").pressed.connect(_leave_dialogue)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): emit_signal("enter_pressed")

func _sharon_dialogue() -> void:
	var new_dia :dialogue_scene = DIALOGUE_SCENE.instantiate()
	new_dia.emit_signal("add_character", true)
	add_child(new_dia)
	_spawn_old_character(new_dia, true, true)
	find_child("UILayer").visible = false
	new_dia.z_index += 5
	new_dia.emit_signal("start_dialogue_animation")
	for i in sharon_dias:
		if new_dia: new_dia.emit_signal("send_dia", i)
		await enter_pressed


func _family_dialogue() -> void:
	var new_dia :dialogue_scene = DIALOGUE_SCENE.instantiate()
	new_dia.emit_signal("add_character", true)
	add_child(new_dia)
	_spawn_old_character(new_dia, true, true)
	find_child("UILayer").visible = false
	new_dia.z_index += 5
	new_dia.emit_signal("start_dialogue_animation")
	for i in family_dias:
		new_dia.emit_signal("send_dia", i)
		await enter_pressed

func _disease_dialogue() -> void:
	var new_dia :dialogue_scene = DIALOGUE_SCENE.instantiate()
	new_dia.emit_signal("add_character", true)
	add_child(new_dia)
	_spawn_old_character(new_dia, true, true)
	find_child("UILayer").visible = false
	new_dia.z_index += 5
	new_dia.emit_signal("start_dialogue_animation")
	for i in disease_dias:
		new_dia.emit_signal("send_dia", i)
		await enter_pressed

	new_dia.queue_free()

func _leave_dialogue():
	#print("Leave")
	var new_dia :dialogue_scene = DIALOGUE_SCENE.instantiate()
	add_child(new_dia)
	_spawn_old_character(new_dia, true, true)
	find_child("UILayer").visible = false
	new_dia.z_index += 5
	new_dia.emit_signal("start_dialogue_animation")
	new_dia.emit_signal("send_dia", "So soon? I’ll be here sweety, waiting for you")
	await enter_pressed
	new_dia.queue_free()
	#$AnimationPlayer.play("fade_to")
	#$BlackScreen.z_index += 10
	#$BlackScreen.visible = true
	#await $AnimationPlayer.animation_finished
	#get_tree().change_scene_to_file("res://Scenes/room_scenes/corridor.tscn")
	navigator.go_to_room("corridor")

func _spawn_old_character(parent : dialogue_scene, visible : bool, speak : bool) -> void:
	var new_old : CHARACTER = OLD.instantiate()
	parent.add_child(new_old)
	parent.emit_signal("add_character", visible)
	new_old.visible = visible
	new_old.emit_signal("set_speak", speak)
