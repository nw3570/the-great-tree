extends StaticBody2D
class_name DOOR

signal yes_pressed
signal no_pressed
const DOOR_OPENING_VF = preload("uid://b5q5bhikwngie")

# ============================================================
# PRELOADS
# ============================================================
const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")
const GOTH = preload("uid://bvn4xvy7a552w")
const OLD = preload("uid://4rdyi8de470a")
const TEEN = preload("uid://cukg7x7vdmjbf")
var dia :dialogue_scene
# ============================================================
# ONREADY / NODE REFS
# ============================================================
var animation_player : AnimationPlayer
var dimmer : Sprite2D
var area : Area2D
var door_name : String
var in_yes:bool = false
var in_no:bool = false
var yes_area :Area2D
var no_area : Area2D
var open_sound : AudioStreamPlayer2D
var close_sound : AudioStreamPlayer2D

# ============================================================
# STATE
# ============================================================
var in_area : bool = false

# ============================================================
# LIFECYCLE
# ============================================================
var buttons : Node2D
func _ready() -> void:
	open_sound = get_parent().find_child("door_open")
	close_sound = get_parent().find_child("door_close")
	buttons = get_parent().find_child("buttons")
	buttons.visible = false
	animation_player = get_parent().find_child("AnimationPlayer")
	dimmer = get_parent().find_child("dimmer")
	area = find_child("Area2D")
	door_name = name
	area.mouse_entered.connect(_mouse_entered)
	area.mouse_exited.connect(_mouse_exited)

	yes_area = get_parent().find_child("buttons").find_child("yes").find_child("Area2D")
	no_area = get_parent().find_child("buttons").find_child("no").find_child("Area2D")
	yes_area.mouse_entered.connect(_mouse_enterd_yes)
	no_area.mouse_entered.connect(_mouse_enterd_no)
	no_pressed.connect(_no_pressed)

func _no_pressed():
	in_no = false
	in_yes = false
	if !get_parent().in_gialogue: return
	get_parent().in_gialogue = false
	var parent = get_parent()
	for i in parent.get_children():
		if i.is_in_group("dia"):
			print("In group")
			i.queue_free()
	animation_player.play("fade_back")
	buttons.visible = false

func _mouse_enterd_yes():
	if !buttons.visible: return
	in_yes = true
	in_no = false

func _mouse_enterd_no():
	if !buttons.visible: return
	in_yes = false
	in_no = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") && in_yes:
		print("Yes pressed")
		emit_signal("yes_pressed")
		return
	elif event.is_action_pressed("LMB") && in_no:
		emit_signal("no_pressed")
		print("No pressed")
		return
	inpsd(event)

func inpsd(event : InputEvent):
	if !event.is_action_pressed("LMB"): return
	if !in_area: return
	_select_dialogue()

# ============================================================
# MOUSE
# ============================================================
func _mouse_entered() -> void:
	in_area = true

func _mouse_exited() -> void:
	in_area = false

# ============================================================
# DIALOGUE
# ============================================================
func _select_dialogue() -> void:
	if get_parent().in_gialogue: return
	get_parent().in_gialogue = true
	dimmer.visible = true
	get_parent().find_child("buttons").visible = true
	animation_player.play("fade_to")
	var new_dia : dialogue_scene = DIALOGUE_SCENE.instantiate()
	dia=new_dia
	new_dia.closing_dialogue.connect(_closing_dia)
	get_parent().add_child(new_dia)

	match door_name:
		"teen_door":         _teen_dialogue(new_dia)
		"goth_door":         _goth_dialogue(new_dia)
		"buisness_door":     _buisness_dialogue(new_dia)
		"divorced_door":     _divorced_dialogue(new_dia)
		"archeologist_door": _archeologist_dialogue(new_dia)
		"old_door":          _old_dialogue(new_dia)

func _closing_dia() -> void:
	animation_player.play("fade_back")
	get_parent().in_gialogue = false
	# dimmer.visible = false

# ============================================================
# DIALOGUE VARIANTS
# ============================================================
func _teen_dialogue(dia : dialogue_scene) -> void:
	var new_teen : CHARACTER = TEEN.instantiate()
	dia.add_child(new_teen)
	dia.emit_signal("add_character", visible)
	new_teen.visible = visible
	print("Teen dialogue")
	dia.emit_signal("send_dia", "Sup dude-I mean sir. Gotta search here, or something?")
	await yes_pressed
	open_sound.play()
	await open_sound.finished
	get_tree().change_scene_to_file("res://Scenes/room_scenes/teen_room.tscn")

func _goth_dialogue(dia : dialogue_scene) -> void:
	var new_goth : CHARACTER = GOTH.instantiate()
	dia.add_child(new_goth)
	dia.emit_signal("add_character", visible)
	new_goth.visible = visible
	dia.emit_signal("send_dia", "Hello, mister. You must be the detective, do you need any help from here?")
	await yes_pressed
	open_sound.play()
	await open_sound.finished
	get_tree().change_scene_to_file("res://Scenes/room_scenes/goth_rooom.tscn")

func _buisness_dialogue(dia : dialogue_scene) -> void:
	print("Buisness dialogue")
	dia.emit_signal("start_dialogue_animation")
	dia.emit_signal("send_dia", "Oh… Hi there. Can I help you, detective?")
	await yes_pressed
	open_sound.play()
	await open_sound.finished

func _divorced_dialogue(dia : dialogue_scene) -> void:
	print("Divorced dialogue")
	dia.emit_signal("start_dialogue_animation")
	dia.emit_signal("send_dia", "Excuse me sir, do you want anything from my room?")
	await yes_pressed
	open_sound.play()
	await open_sound.finished

func _archeologist_dialogue(dia : dialogue_scene) -> void:
	print("Archeologist dialogue")
	dia.emit_signal("start_dialogue_animation")
	dia.emit_signal("send_dia", "Hello sir, can I be of any help?")
	await yes_pressed
	open_sound.play()
	await open_sound.finished
	

func _old_dialogue(dia : dialogue_scene) -> void:
	var new_old : CHARACTER = OLD.instantiate()
	dia.add_child(new_old)
	dia.emit_signal("add_character", visible)
	new_old.visible = visible
	dia.emit_signal("send_dia", "Hello there, does the gentleman need to come inside?")
	await yes_pressed
	open_sound.play()
	await open_sound.finished
	get_tree().change_scene_to_file("res://Scenes/room_scenes/granny.tscn")
