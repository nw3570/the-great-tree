extends Node
class_name GS

const SAVE_PATH := "user://save.cfg"

var has_key: bool = false

func _ready() -> void:
	load_game()

func save_game() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("flags", "has_key", has_key)
	cfg.save(SAVE_PATH)

func load_game() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	has_key = cfg.get_value("flags", "has_key", false)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
