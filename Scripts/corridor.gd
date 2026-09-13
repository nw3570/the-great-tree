extends Room

var in_gialogue : bool = false

# Ir para o tree_room quando clicar no passage.
func _on_passage_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventMouseButton || !event.is_action_pressed("LMB"):
		return
	
	navigator.go_to_room("tree_room")
