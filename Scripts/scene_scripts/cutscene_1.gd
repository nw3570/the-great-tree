extends Node2D

# ---------------------------------------------------------------------------
# INTRO DIALOGUE CONTROLLER
# Plays the opening monologue line by line, then transitions to the case scene.
#
# Flow:
#   _ready()      → spawns the dialogue scene and starts the sequence
#   _start_dia()  → sends each line, waits for `enter_pressed`, then changes scene
#   _input()      → handles Enter/Space: first press skips typing, next advances
# ---------------------------------------------------------------------------

const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")

## The full intro script, one string per dialogue box.
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

## The instantiated dialogue scene (exposes `send_dia`, `writing`, `skip`,
## and the `dialogue_skipped` signal).
var dia : dialogue_scene

## Emitted to advance to the next line.
## Also emitted automatically when a line finishes typing (via skipped_dialogue).
signal enter_pressed


# ---------------------------------------------------------------------------
# LIFECYCLE
# ---------------------------------------------------------------------------

func _ready() -> void:
	var new_dia = DIALOGUE_SCENE.instantiate()
	add_child(new_dia)
	dia = new_dia
	new_dia.emit_signal("start_dialogue_animation")
	new_dia.emit_signal("send_dia")
	new_dia.dialogue_skipped.connect(skipped_dialogue)
	_start_dia()


func _input(event: InputEvent) -> void:
	# Enter while text is still typing → skip the typing animation only.
	if event.is_action_pressed("ui_accept") && dia.writing == true:
		dia.skip = true
		return

	# Enter after typing finished → advance to the next line.
	if event.is_action_pressed("ui_accept"):
		emit_signal("enter_pressed")
		print("Next dia")


# ---------------------------------------------------------------------------
# DIALOGUE FLOW
# ---------------------------------------------------------------------------

## Runs through `first_dia` line by line, waiting for `enter_pressed` between
## each. When done, frees the dialogue node and loads the case scene.
func _start_dia():
	for i in first_dia:
		#print(i)

		dia.emit_signal("send_dia", i)
		await enter_pressed
		
	dia.queue_free()
	#get_tree().change_scene_to_file("res://Scenes/room_scenes/case_scene.tscn")
	SceneManager.switch_scene_to_file(self, "res://Scenes/gameplay.tscn")
	await SceneManager.switch_completed


## Called when the dialogue box finishes typing on its own.
## Treated as an advance so the player doesn't press Enter twice per line.
func skipped_dialogue():
	emit_signal("enter_pressed")
