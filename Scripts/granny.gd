extends Room

@onready var _ui: CharacterRoomUI = $UILayer/CharacterRoomUI

func _ready() -> void:
	#_ui.add_leave_room_option(navigator)
	
	# Connect options_menu buttons to dialogues/interactions.
	var options_menu := _ui.get_options_menu()
	options_menu.add_option("Sharon")
	options_menu.add_option("Family")
	options_menu.add_option("Disease")
	options_menu.add_option("Leave")
	options_menu.get_option_button("Sharon").pressed.connect(_sharon_dialogue)
	options_menu.get_option_button("Family").pressed.connect(_family_dialogue)
	options_menu.get_option_button("Disease").pressed.connect(_disease_dialogue)

func _sharon_dialogue() -> void:
	pass

func _family_dialogue() -> void:
	pass

func _disease_dialogue() -> void:
	pass
