extends Node

@onready var player_camera: PlayerCamera2D = $PlayerCamera2D

#var game_context: GameContext = null
var navigator := RoomNavigator.new()

func _ready() -> void:
	navigator.room_transition_started.connect(_on_navigator_room_transition_started)
	#navigator.set_initial_room(self, "corridor")

func _on_navigator_room_transition_started(new_room: Room) -> void:
	#new_room.game_context = game_context
	new_room.navigator = navigator
	player_camera.set_bounds(new_room.get_background_visible_rect())
	player_camera.global_position = new_room.get_camera_spawn_position()
