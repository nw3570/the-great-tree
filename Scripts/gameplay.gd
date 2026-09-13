extends Node

#@onready var player_camera: PlayerCamera2D = $PlayerCamera2D

var navigator := RoomNavigator.new()
var game_flags: Dictionary[String, bool]

func _ready() -> void:
	SceneManager.fade = $Fade
	navigator.room_transition_started.connect(_on_navigator_room_transition_started)
	navigator.set_initial_room(self, "corridor")

func _on_navigator_room_transition_started(_new_room: Room) -> void:
	#new_room.game_flags = game_flags
	#player_camera.set_bounds(new_room.get_background_visible_rect())
	#player_camera.global_position = new_room.get_camera_spawn_position()
	pass
