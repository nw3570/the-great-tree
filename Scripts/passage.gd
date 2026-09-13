extends Area2D

## The destination that the door leads to.
#@export var destination_room_id: String
#
#var in_area : bool = false
#
#func _ready() -> void:
	#mouse_entered.connect(_entered)
	#mouse_exited.connect(_exited)
#
#func _entered():
	#in_area = true
#
#func _exited():
	#in_area = false
#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("LMB"):
		#if in_area:
			#get_tree().change_scene_to_file("res://Scenes/room_scenes/tree_room.tscn")
