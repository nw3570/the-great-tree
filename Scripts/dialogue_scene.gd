extends Node2D
class_name dialogue_scene

# ============================================================
# SIGNALS
# ============================================================
signal closing_dialogue
signal add_character
signal send_dia(dia : String)
signal dialogue_finish
signal start_dialogue_animation
signal dialogue_skipped
signal pressed_enter
signal hide_char

# ============================================================
# ONREADY NODES
# ============================================================
@onready var dialogue: Label = $dialogue
@onready var text_delay: Timer = $text_delay
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# ============================================================
# VARIABLES
# ============================================================
var character : CHARACTER
var first_dia_started : bool = false
var animation_finished : bool = false
var writing : bool = false
var skip : bool = false
var ap : AudioStreamPlayer2D

# ============================================================
# LIFECYCLE
# ============================================================
func _ready() -> void:
	dialogue.text = ""
	visible = false
	add_character.connect(_character_added)
	send_dia.connect(_send_dialogue)
	start_dialogue_animation.connect(_start_gialogue_anim)
	hide_char.connect(_hide_char)
	emit_signal("start_dialogue_animation")

func _hide_char():
	character.visible = false
	ap.autoplay = false
	ap.stop()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): emit_signal("pressed_enter")
	if (event.is_action_pressed("ui_cancel")):
		if ui: ui.visible = true
		queue_free()
		emit_signal("closing_dialogue")


# ============================================================
# CHARACTER
# ============================================================
func _character_added(vis : bool):
	for child in get_children():
		if child.is_in_group("character"):
			print(child.get_groups())
			character = child
	character.name = "CHARACTER"
	character.visible = vis

# ============================================================
# ANIMATION
# ============================================================
func _start_gialogue_anim():
	
	visible = true
	animation_player.play("dialogue_start")
	await animation_player.animation_finished

	#emit_signal("add_character")
	#if !character:
		#for child in get_children():
			#if child.is_in_group("character"):
				#print(child.get_groups())
				#character = child
	if character: character.emit_signal("set_speak", true)
	if character: character._move()

# ============================================================
# DIALOGUE
# ============================================================
var ui
func _send_dialogue(dial):
	print(dial)
	ui = get_parent().find_child("UILayer")
	if ui: ui.visible = false
	if dial is String:
		if !animation_finished:
			await animation_player.animation_finished
			animation_finished = true
		_write_dialogue(dial)
	elif dial is Array:
		for i in dial:
			if !animation_finished:
				await animation_player.animation_finished
				animation_finished = true
			_write_dialogue(i)
			await dialogue_finish
			await pressed_enter
			if i == dial[dial.size()-1]:
				if ui: ui.visible = true
				queue_free()
				return
			character.emit_signal("set_speak", true)
			character.visible = true
			character.emit_signal("set_speak", true)



func _write_dialogue(Dia : String):
	writing = true
	dialogue.text = ""
	var char_count : int = 0
	var words = Dia.split(" ")
	var word_letter_count : int = 0
	text_delay.autostart = true
	text_delay.start(.05)

	for word in words:
		var temp_count : int = 0

		if (skip):
			skip = false
			dialogue.text = ""
			writing = false
			emit_signal("dialogue_skipped")
			return

		for letter in word:
			word_letter_count += 1
			char_count += 1
			if char_count >= 55 || char_count + word_letter_count >= 55:
				dialogue.text = dialogue.text + "\n"
				char_count = 0

		for letter in word:
			dialogue.text = dialogue.text + letter
			temp_count += 1
			await text_delay.timeout

		if (temp_count == word.length()):
			dialogue.text = dialogue.text + " "

		word_letter_count = 0

	print("Ended")
	text_delay.autostart = false
	text_delay.stop()
	emit_signal("dialogue_finish")
	writing = false
	if character: character.emit_signal("set_speak", false)
