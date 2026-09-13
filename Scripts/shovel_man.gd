extends CHARACTER
@onready var final_choice: Node2D = $"../final_choice"

@onready var button: Button = $"../Button"
const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")

func _ready():
	button.pressed.connect(_pressed)

func _pressed():
	var new_dia : dialogue_scene = DIALOGUE_SCENE.instantiate()
	get_parent().add_child(new_dia)
	final_choice.visible = true
	final_choice.dia = new_dia
	new_dia.find_child("WDithering").visible = false
	new_dia.emit_signal("start_dialogue_animation")
	new_dia.emit_signal("send_dia", "Ready to put this shovel to good use?")
