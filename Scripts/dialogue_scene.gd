extends Node2D
class_name dialogue_scene
@onready var dialogue: Label = $dialogue
@onready var text_delay: Timer = $text_delay

signal closing_dialogue
signal add_character
signal send_dia(dia : String)
signal dialogue_finish
signal start_dialogue_animation
var character : CHARACTER
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var first_dia_started : bool = false
signal next_dia
var first_dia = ["Hey kid, so you’re the new detective?",
"You’ve finished the phytologist academy. You should know the drill.",
"Someone here made a grave mistake.",
" Why me? I can see the question on your face.",
"It’s simple. We don’t want to spill good blood.",
"This heretic took it upon themselves to wound The Tree of All Being, and they will pay for it. Their body will be consumed by The Great Being as punishment.",
"You know the rules. Screw this up and you’ll be joining the reprobate as soil enrichment.",
"Don’t try to cheat your way out of this one, It will know.",
"So… We traced the crime to one of 6 residents from the east hallway.",
"The house of The Tree of All Being is filled with people that search for spiritual guidance.",
"In other words, most of them are dead broke and looking for a way out. The Tree may help them.",
"But between them can be some filthy heretics, the worst of society.",
"Now, I’ll give you the files of the suspects. Feel free to search their rooms and ask them some questions.",
"The community bathrooms and canteen have already been revised, to no avail.",
"You can also check the crime scene, next to it there will be the one who will do the dirty work, just need to give him a heads up.",
"Go do your work. Good luck, boy."]

func _ready() -> void:
	dialogue.text = ""
	add_character.connect(_character_added)
	visible = false
	send_dia.connect(_send_dialogue)
	start_dialogue_animation.connect(_start_gialogue_anim)
	#goth.rotation = 0

func _character_added():
	for child in get_children():
		if child.is_in_group("character"):
			character = child
	character.name = "CHARACTER"

func _input(event: InputEvent) -> void:
	#if (event.is_action_pressed("ui_accept")): emit_signal("start_dialogue_animation")

	if (event.is_action_pressed("ui_cancel")):
		queue_free()
		emit_signal("closing_dialogue")

	#if(event.is_action_pressed("ui_cancel")&&first_dia_started == true): emit_signal("next_dia")
	#if(event.is_action_pressed("ui_cancel")&&first_dia_started == false):
		#first_dia_started = true
		#_start_first_dialogue()
		#emit_signal("next_dia")

func _start_gialogue_anim():
	visible = true
	animation_player.play("dialogue_start")
	await animation_player.animation_finished
	if !character: return
	character.emit_signal("set_speak", true)
	character._move()

func _send_dialogue(dial):
	await animation_player.animation_finished
	#await next_dia
	_write_dialogue(dial)
	#await dialogue_finish

func _start_first_dialogue():
	#for i in first_dia:
		##print(i)
		#await next_dia
		#_write_dialogue(i)
		#await dialogue_finish
	#dialogue.text = ""
	#animation_player.play("idle_dialogue")
	pass

func _write_dialogue(Dia : String):
	dialogue.text = ""
	var char_count : int = 0
	var words = Dia.split(" ")
	var word_letter_count : int = 0
	text_delay.autostart = true
	text_delay.start(.05)
	for word in words:
		var temp_count : int = 0
		for letter in word:
			word_letter_count += 1
			char_count += 1
			if char_count >= 60 || char_count + word_letter_count >= 60:
				dialogue.text = dialogue.text+"\n"
				char_count = 0

		for letter in word:
			dialogue.text = dialogue.text + letter
			temp_count += 1
			await text_delay.timeout


		if (temp_count == word.length()): dialogue.text = dialogue.text + " "

		word_letter_count = 0
	text_delay.autostart = false
	text_delay.stop()
	emit_signal("dialogue_finish")
