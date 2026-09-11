extends StaticBody2D
class_name DOOR

const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")

const GOTH = preload("uid://bvn4xvy7a552w")
const OLD = preload("uid://4rdyi8de470a")

var animation_player : AnimationPlayer
var dimmer : Sprite2D
var area : Area2D
var door_name : String
var in_area : bool = false

func _ready() -> void:
	animation_player = get_parent().find_child("AnimationPlayer")
	dimmer = get_parent().find_child("dimmer")
	area = find_child("Area2D")
	door_name = name
	area.mouse_entered.connect(_mouse_entered)
	area.mouse_exited.connect(_mouse_exited)

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("LMB"):return
	if !in_area: return
	_select_dialogue()

func _select_dialogue():
	dimmer.visible = true
	animation_player.play("fade_to")
	var new_dia :dialogue_scene = DIALOGUE_SCENE.instantiate()
	new_dia.closing_dialogue.connect(_closing_dia)
	get_parent().add_child(new_dia)
	match door_name:
		"teen_door": _teen_dialogue(new_dia)
		"goth_door": _goth_dialogue(new_dia)
		"buisness_door": _buisness_dialogue(new_dia)
		"divorced_door": _divorced_dialogue(new_dia)
		"archeologist_door": _archeologist_dialogue(new_dia)
		"old_door": _old_dialogue(new_dia)

func _closing_dia():
	animation_player.play("fade_back")
	#dimmer.visible = false

func _teen_dialogue(dia : dialogue_scene):
	print("Teen dialogue")
	dia.emit_signal("start_dialogue_animation")
	dia.emit_signal("send_dia", "Sup dude-I mean sir. Gotta search here, or something?")

func _goth_dialogue(dia : dialogue_scene):
	var new_goth = GOTH.instantiate()
	dia.add_child(new_goth)
	dia.emit_signal("add_character")
	print("Goth dialogue")
	dia.emit_signal("start_dialogue_animation")
	dia.emit_signal("send_dia", "Hello, mister. You must be the detective, do you need any help from here?")

func _buisness_dialogue(dia : dialogue_scene):
	print("Buisness dialogue")
	dia.emit_signal("start_dialogue_animation")
	dia.emit_signal("send_dia", "Oh… Hi there. Can I help you, detective?")

func _divorced_dialogue(dia : dialogue_scene):
	print("Divorced dialogue")
	dia.emit_signal("start_dialogue_animation")
	dia.emit_signal("send_dia", "Excuse me sir, do you want anything from my room?")

func _archeologist_dialogue(dia : dialogue_scene):
	print("Archeologist dialogue")
	dia.emit_signal("start_dialogue_animation")
	dia.emit_signal("send_dia", "Hello sir, can I be of any help?")

func _old_dialogue(dia : dialogue_scene):
	var new_old = OLD.instantiate()
	dia.add_child(new_old)
	dia.emit_signal("add_character")
	print("Archeologist dialogue")
	dia.emit_signal("start_dialogue_animation")
	dia.emit_signal("send_dia", "Hello there, does the gentleman need to come inside?")


func _mouse_entered():
	in_area = true

func _mouse_exited():
	in_area = false
