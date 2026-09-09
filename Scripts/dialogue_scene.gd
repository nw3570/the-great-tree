extends Node2D
@onready var dialogue: Label = $dialogue
@onready var text_delay: Timer = $text_delay

signal start_dialogue_animation
var character : CHARACTER
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	dialogue.text = ""
	for child in get_children():
		if child.is_in_group("character"):
			character = child
	
	character.name = "CHARACTER"
	visible = false
	start_dialogue_animation.connect(_start_gialogue_anim)
	#goth.rotation = 0

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")): emit_signal("start_dialogue_animation")
	if(event.is_action_pressed("ui_cancel")): _write_dialogue("Testing dialogue system. If the abc is the most powerfull when does the ship sink after the plane has liftoff while the security of the people is in the hand of the man who went to the store to be shot and killed by his only friend while the mountain crawls up itself. ")

func _start_gialogue_anim():
	visible = true
	animation_player.play("dialogue_start")
	await animation_player.animation_finished
	character.emit_signal("set_speak", true)
	character._move()

func _write_dialogue(Dia : String):
	var char_count : int = 0
	var words = Dia.split(" ")
	var word_letter_count : int = 0
	text_delay.autostart = true
	text_delay.start(.1)
	for word in words:
		var temp_count : int = 0
		for letter in word:
			word_letter_count += 1
			char_count += 1
			if char_count >= 60 || char_count + word_letter_count >= 65:
				dialogue.text = dialogue.text+"\n"
				char_count = 0

			dialogue.text = dialogue.text + letter
			temp_count += 1
			if (temp_count == word.length()): dialogue.text = dialogue.text + " "
			await text_delay.timeout

		word_letter_count = 0
		#await text_delay.timeout
	text_delay.autostart = false
	text_delay.stop()
