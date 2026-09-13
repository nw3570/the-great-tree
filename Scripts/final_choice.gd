extends Node2D
@onready var charachters: Node2D = $charachters
@onready var initial_choice: Node2D = $initial_choice

@onready var goth: Button = $charachters/goth
@onready var teen: Button = $charachters/BoxContainer/teen
@onready var arch: Button = $charachters/BoxContainer/arch
@onready var old: Button = $charachters/BoxContainer/old
@onready var buisness: Button = $charachters/BoxContainer/buisness
@onready var divorced: Button = $charachters/BoxContainer/divorced
@onready var not_yet: Button = $charachters/not_yet

@onready var yes: Button = $initial_choice/VBoxContainer/yes
@onready var no: Button = $initial_choice/VBoxContainer/no

var can_choose : bool = false

signal close_dia
signal chose_character(Char : String)
signal pressed(button:String)

var dia : dialogue_scene
var room : Room
var CHARS : Array = ["goth", "teen", "arch", "old", "buisness", "divorced"]

func _ready() -> void:
	room = get_parent()
	

	goth.pressed.connect(func(): emit_signal("pressed", "goth"))
	teen.pressed.connect(func(): emit_signal("pressed", "teen"))
	arch.pressed.connect(func(): emit_signal("pressed", "arch"))
	old.pressed.connect(func(): emit_signal("pressed", "old"))
	buisness.pressed.connect(func(): emit_signal("pressed", "buisness"))
	divorced.pressed.connect(func(): emit_signal("pressed", "divorced"))
	not_yet.pressed.connect(func(): emit_signal("pressed", "not_yet"))

	yes.pressed.connect(func(): emit_signal("pressed", "yes"))
	no.pressed.connect(func(): emit_signal("pressed", "no"))

	pressed.connect(_pressed)

func _pressed(button : String):
	match button:
		"no": if dia: dia.queue_free(); visible = false
		"yes": _change_selection()

	if CHARS.has(button): emit_signal("chose_character", button)
	if button == "not_yet": _change_selection()



func _change_selection():
	if !can_choose:
		can_choose = true
		charachters.visible = true
		initial_choice.visible = false
		not_yet.visible = true
		return
	if can_choose:
		not_yet.visible = false
		can_choose = false
		charachters.visible = false
		initial_choice.visible = true
		return
