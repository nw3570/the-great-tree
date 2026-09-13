extends Area2D

@onready var _audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event is not InputEventMouseButton || event.is_action_pressed("LMB"):
		return
	
	_audio_player.play()
	viewport.set_input_as_handled()
