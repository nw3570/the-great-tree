extends Node
class_name Gameplay

#@onready var player_camera: PlayerCamera2D = $PlayerCamera2D

enum CulpritCharacter {
	JANET,
	WILLIAM
}

var game_flags: Dictionary[String, bool]
var initial_room_id: String
var culprit: CulpritCharacter

var navigator := RoomNavigator.new()

func _ready() -> void:
	SceneManager.fade = $Fade
	_resolve_initial_state()
	
	navigator.room_transition_started.connect(_on_navigator_room_transition_started)
	navigator.set_initial_room(self, initial_room_id)

func _on_navigator_room_transition_started(new_room: Room) -> void:
	new_room.game_flags = game_flags
	new_room.culprit = culprit
	#player_camera.set_bounds(new_room.get_background_visible_rect())
	#player_camera.global_position = new_room.get_camera_spawn_position()

# If there is a save file, call _recover_from_save. Otherwise, call
# _new_game.
func _resolve_initial_state() -> void:
	_new_game()

# Must set initial_room, culprit and game_flags from save file
func _recover_from_save() -> void:
	pass

# Must set defaults for initial_room, culprit and game_flags when no save file.
func _new_game() -> void:
	initial_room_id = "case_scene"
	game_flags = {}
	culprit = CulpritCharacter.values().pick_random()

func _write_save() -> void:
	pass

# Save states of gameplay (navigator._current_room, game_flags, culprit) in file
func _exit_tree() -> void:
	pass

# Save states of gameplay (navigator._current_room, game_flags, culprit) in file
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		pass
