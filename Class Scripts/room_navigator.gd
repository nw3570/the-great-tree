extends RefCounted
class_name RoomNavigator

const SCENES_DIR := "res://Scenes/room_scenes/"

signal room_transition_started(new_room: Room)

var _current_room: Room = null
var _current_room_id: String
var _history: Array[String] = []

func set_initial_room(room_container: Node, room_id: String) -> void:
	_current_room = _get_room_instance(room_id)
	_current_room_id = room_id
	
	#SceneManager.transition_hide()
	room_transition_started.emit(_current_room)
	room_container.add_child(_current_room)
	#SceneManager.transition_reveal()

func go_to_room(room_id: String):
	assert(
		_current_room != null,
		"Can't go to another room before set_initial_room() has been called."
	)
	
	_history.push_back(_current_room_id)
	_switch_room(room_id)

func can_go_back() -> bool:
	return !_history.is_empty()

func go_back() -> void:
	if !can_go_back():
		return
	
	var previous_room = _history.pop_back()
	_switch_room(previous_room)

func clear_history() -> void:
	_history = []

func _get_room_instance(room_id: String) -> Room:
	return SceneManager.scene_instance(SCENES_DIR + room_id + ".tscn")

func _switch_room(new_room_id: String) -> void:
	var new_room := _get_room_instance(new_room_id)
	
	#SceneManager.transition_hide()
	room_transition_started.emit(new_room)
	
	SceneManager.switch_scene_to_node(_current_room, new_room)
	await SceneManager.switch_completed
	
	_current_room = new_room
	_current_room_id = new_room_id
	#SceneManager.transition_reveal()
