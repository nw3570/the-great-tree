extends Area2D

## The destination that the door leads to.
@export var destination_room_id: String

func _ready() -> void:
	pass

func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventMouseButton && !event.is_action_pressed("LMB"):
		return
	
	#go_to_room(destination_room_id)
