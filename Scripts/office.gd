extends Room

@onready var _ui = $UILayer

func _ready() -> void:
	background = $Background
	_ui.hide()
	#_advance_btn.pressed.connect(_on_advance_button_pressed)

func play_cutscene() -> void:
	# Play the initial dialogue and/or animations.
	_on_cutscene_end()

# Allow the player to interact with the character's files.
# Show UI so the player is able to click an "Advance" button to continue.
func _on_cutscene_end() -> void:
	_ui.show()

func _on_advance_button_pressed() -> void:
	#go_to_room("corridor").
	pass
