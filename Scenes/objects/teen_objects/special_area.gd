extends Area2D

var GameState : GS = GS.new()
var in_area : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") && in_area:
		GameState.has_key = true
		GameState.save_game()
		var new_state : GS =GS.new()
		new_state.load_game()
		if new_state.has_key: print("Has Key")

func _on_mouse_entered() -> void:
	in_area = true

func _on_mouse_exited() -> void:
	in_area = false
