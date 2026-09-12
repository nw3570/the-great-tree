extends Node

@onready var player_camera: PlayerCamera2D = $PlayerCamera2D

var navigator := RoomNavigator.new()

func _ready() -> void:
	navigator.room_transition_started.connect(_on_navigator_room_transition_started)
	navigator.set_initial_room(self, "granny")

#func _on_object_interacted(_game_object) -> void:
	#game_object.in_game_interaction(game_context)

func _on_navigator_room_transition_started(new_room: Room) -> void:
	player_camera.set_bounds(new_room.get_background_visible_rect())
	player_camera.global_position = new_room.get_camera_spawn_position()
	
	# For all objects in the current room, connect to the interaction signal.
	#for game_object in get_tree().get_nodes_in_group("game_object"):
		#if game_object.mouse_clicked:
			#game_object.mouse_clicked.connect(_on_object_interacted)
