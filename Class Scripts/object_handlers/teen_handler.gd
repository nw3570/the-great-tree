extends MAIN_OBJ_HANDLER
class_name TEEN_OBJ_HANDLER


# ============================================================
# PRELOADS
# ============================================================
const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")
const TEEN = preload("uid://cukg7x7vdmjbf")

# ============================================================
# SIGNALS
# ============================================================
signal next_dialogue

# ============================================================
# DIALOGUE STRINGS
# ============================================================
var graffiti : String  = "So he’s an artist? Maybe just a vandal"
var road_sign : String  = "I think that’s a crime, but it ain’t my problem"
var bed : String  = "An old mattress, a dirty blanket and a smelly pillow. Is this considered a bed?"

var skateboard : String  = "You know… it happens to the best. I think I broke this one in the park nearby.  Not that big of a deal."
var guitar : String = "Yeah, that's what a well-loved guitar looks like. Wanna show your artistic side?"
var poster : String = "It’s just my favorite band, don’t stress about it."

var skateboard_2 : String = "It can still be used as a  weapon"
# ============================================================
# STATE
# ============================================================
var dia : dialogue_scene

# ============================================================
# INTERACTION
# ============================================================
func _interacted_with(STR : String, wor : Node2D) -> void:
	print(STR)
	print(wor)
	match STR.to_lower():
		"graffiti":    _dia_handler(graffiti, wor)
		"road_sign":   _dia_handler(road_sign, wor)
		"bed":   _dia_handler(bed, wor)
		"skateboard":      _dia_handler(skateboard, wor)
		"guitar": _dia_handler(guitar, wor)
		"poster": _dia_handler(poster, wor)

# ============================================================
# DIALOGUE HANDLER
# ============================================================
func _dia_handler(STR : String, wor : Node2D) -> void:
	var new_dia : dialogue_scene = DIALOGUE_SCENE.instantiate()
	dia = new_dia
	wor.add_child(new_dia)
	new_dia.z_index = 3
	new_dia.find_child("WDithering").visible = false
	new_dia.emit_signal("start_dialogue_animation")

	# --- Multi-line dialogue with old character (wet book) ---
	if STR == skateboard:
		var arr = [STR, skateboard_2]
		new_dia.emit_signal("send_dia", arr)
		_spawn_teen(new_dia, false, false)
		return

	# --- Single-line dialogues with old character ---
	if  STR == guitar or STR == poster:
		new_dia.emit_signal("send_dia", STR)
		_spawn_teen(new_dia, true, true)
		return

	new_dia.emit_signal("send_dia", STR)
	return


# ============================================================
# HELPERS
# ============================================================
func _spawn_teen(parent : dialogue_scene, visible : bool, speak : bool) -> void:
	var new_teen : CHARACTER = TEEN.instantiate()
	parent.add_child(new_teen)
	parent.emit_signal("add_character", visible)
	new_teen.visible = visible
	new_teen.emit_signal("set_speak", speak)
