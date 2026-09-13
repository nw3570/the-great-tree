extends Room

@onready var _ui: CanvasLayer = $UILayer
@onready var _advance_btn: Button = $UILayer/Advance

func _ready() -> void:
	play_cutscene()

func play_cutscene() -> void:
	# Play the initial dialogue and/or animations.
	_on_cutscene_end()

# Allow the player to interact with the character's files.
# Show UI so the player is able to click an "Advance" button to continue.
func _on_cutscene_end() -> void:
	_advance_btn.pressed.connect(_on_advance_button_pressed)
	_ui.show()

func _on_advance_button_pressed() -> void:
	navigator.go_to_room("corridor")
