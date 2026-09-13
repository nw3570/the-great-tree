extends CanvasLayer
class_name Fade

@export var duration := 0.5

@onready var _rect = $FadeRect

func _ready() -> void:
	_rect.modulate.a = 0.0

func fade_in():
	show()
	var tween := create_tween()
	
	tween.tween_property(_rect, "modulate:a", 1.0, duration)
	await tween.finished

func fade_out():
	var tween := create_tween()
	
	tween.tween_property(_rect, "modulate:a", 0.0, duration)
	await tween.finished
	hide()
