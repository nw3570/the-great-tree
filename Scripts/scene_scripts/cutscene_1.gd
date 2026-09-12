extends Node2D

const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")

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

var dia : dialogue_scene 
signal enter_pressed

func _ready() -> void:
	var new_dia = DIALOGUE_SCENE.instantiate()
	add_child(new_dia)
	dia = new_dia
	new_dia.emit_signal("start_dialogue_animation")
	new_dia.emit_signal("send_dia")
	new_dia.dialogue_skipped.connect(skipped_dialogue)
	_start_dia()

func skipped_dialogue():
	emit_signal("enter_pressed")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") && dia.writing == true:
		dia.skip = true
		return
	if event.is_action_pressed("ui_accept"): 
		emit_signal("enter_pressed")
		print("Next dia")

func _start_dia():
	for i in first_dia:
		#print(i)
		
		dia.emit_signal("send_dia", i)
		await enter_pressed
	dia.queue_free()
	get_tree().change_scene_to_file("res://Scenes/room_scenes/corridor.tscn")
