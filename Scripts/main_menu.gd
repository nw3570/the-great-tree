extends Node2D
@onready var start_button: Button = $start_button
@onready var credits: Button = $credits
@onready var options: Button = $options

func _ready() -> void:
	start_button.pressed.connect(_start_game)

func _start_game():
	get_tree().change_scene_to_file("res://Scenes/cutscene_1.tscn")

func _options():
	pass

func _credits():
	pass
