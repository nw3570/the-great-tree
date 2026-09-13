extends Room

# ---------------------------------------------------------------------------
# CASE FILE ROOM
# Handles hover detection and info-panel display for case-file objects.
# When the player hovers a case file and left-clicks, the corresponding
# character info is shown in the `info` panel.
# ---------------------------------------------------------------------------

@onready var info: Node2D = $info

## True while the mouse is hovering over any case-file's Area2D.
var in_area: bool = false

## Name (lowercase, matching the match statement below) of the case file
## currently under the cursor. Empty string when nothing is hovered.
var current_case: String = ""

## All case-file objects in this room, collected on _ready().
var objects: Array = []


# ---------------------------------------------------------------------------
# LIFECYCLE
# ---------------------------------------------------------------------------

func _ready() -> void:
	# Collect all case-file objects and hook their hover areas to our handlers.
	for child in get_children():
		if not child.is_in_group("case_files"):
			continue

		var obj: OBJECT = child
		objects.append(obj)

		# Find the Area2D child used for mouse detection.
		var area: Area2D = null
		for a in child.get_children():
			if a is Area2D:
				area = a
				break

		if area:
			area.mouse_entered.connect(_entered)
			area.mouse_exited.connect(_exited)


func _physics_process(_delta: float) -> void:
	# Track which case file is currently selected (OBJECT sets `selected`
	# on mouse_entered and clears it on mouse_exited).
	for obj: OBJECT in objects:
		if obj.selected:
			current_case = obj.name
			return
	# Nothing selected — clear so the click handler below is a no-op.
	current_case = ""


func _input(event: InputEvent) -> void:
	# Left-click while hovering a case file → show its info.
	if event.is_action_pressed("LMB") and in_area and current_case != "":
		set_info()


# ---------------------------------------------------------------------------
# HOVER HANDLERS
# ---------------------------------------------------------------------------

## Called when the mouse enters any case-file's Area2D.
func _entered() -> void:
	in_area = true


## Called when the mouse leaves any case-file's Area2D.
func _exited() -> void:
	current_case = ""
	in_area = false


# ---------------------------------------------------------------------------
# INFO PANEL
# ---------------------------------------------------------------------------

## Fills the info panel with the data for `current_case` and shows it.
## The panel must contain child nodes named: name, profession, age, details.
func set_info() -> void:
	info.visible = true

	match current_case:
		"sharon":
			_set_info_fields(
				"Sharon Smith",
				"Goth",
				"23",
				"She had to go here because she didn't have money as an artist and her parents thought it would be good for her. She has a little black cat and evil symbols in her room. She's in the second room at the left of the hallway."
			)
		"jacob":
			_set_info_fields(
				"Jacob Masson",
				"Teen",
				"19",
				"Left home because his parents kicked him out. Has quite an attitude. Was the last one to arrive. He occupies the first room at the left of the hallway."
			)
		"william":
			_set_info_fields(
				"William Johnson",
				"Businessman",
				"44",
				"He is trying to find meaning in life, his job also doesn't pay that well while the prices keep rising. He spends most of his time in the office, is only home to sleep and Sundays. He always looks tired. He's in the third room at the left of the hallway."
			)
		"karen":
			_set_info_fields(
				"Karen Meyers",
				"Divorced",
				"51",
				"Her husband divorced her and took the kids, she's here as advised by her therapist friend. She loses her temper with ease. Has always a fake smile on. She's in the third room at the right."
			)
		"janet":
			_set_info_fields(
				"Janet Geller",
				"Archeologist",
				"57",
				"Moved there to save money and focus on her studies. She was injured in an accident while retrieving fossils, hence the scars. She is friendly but doesn't like to talk about her past. She's in the first room at right of the hallway."
			)
		"dolores":
			_set_info_fields(
				"Dolores Pines",
				"Elderly woman",
				"71",
				"She lost her husband and her kids don't take care of her so she ends up here. She is still pretty sweet. Sometimes she cooks. She's in the second room at the right of the hallway."
			)


## Helper that fills the four standard fields of the info panel.
func _set_info_fields(char_name: String, profession: String, age: String, details: String) -> void:
	info.find_child("name").text = char_name
	info.find_child("profession").text = profession
	info.find_child("age").text = age
	info.find_child("details").text = details


# ---------------------------------------------------------------------------
# NAVIGATION
# ---------------------------------------------------------------------------

## Returns to the corridor when the "Next" button is pressed.
func _on_next_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/room_scenes/corridor.tscn")
	navigator.go_to_room("corridor")
