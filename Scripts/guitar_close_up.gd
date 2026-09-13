extends Node2D

signal got_key

@onready var key_area: Area2D = $Sprite2D/KeyArea

func _ready() -> void:
	key_area.input_event.connect(_on_key_area_input_event)

func _on_key_area_input_event(viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventMouseButton || event.is_action_pressed("LMB"):
		return
	
	got_key.emit()
	viewport.set_input_as_handled()
