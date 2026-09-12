extends MAIN_OBJ_HANDLER
class_name GOTH_OBJ_HANDLER

const GOTH = preload("uid://bvn4xvy7a552w")

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
var symbol : String  = "That’s the symbol of that evil cult."
var candles : String  = "Is this just for aesthetics or also a ritual?"

var painting : String  = "That’s one of my paintings, my livelihood."
var painting_2 : String  = "Usually I paint stuff that just comes to my mind, especially in my dreams."
var painting_3 : String = "I’m open if you want to buy it by the way."

var nazi : String  = "Political… I see."
var nazi_2 : String  = "Yeah, you can say so."
var nazi_3 : String  = "I don’t like foundations that oppress people."
var nazi_4 : String  = "Don’t worry, don’t worry. I don’t think the phytologist counsel is evil…  "


var cat : String = "Oh, that 's Pixie. Don’t mind him, he doesn’t do much."
var cat_2 : String = "Well, he does drop some fur here and there."
var cat_3 : String = "And sometimes he gets to the others’ rooms and brings home his “prizes”."
var cat_4 : String = "Most of the time it’s useless random stuff, but when something meaningful goes missing I’m more than glad to help"



#	var skateboard_2 : String = "It can still be used as a  weapon"
# ============================================================
# STATE
# ============================================================
var dia : dialogue_scene

# ============================================================
# INTERACTION
# ============================================================
func _interacted_with(STR : String, wor : Node2D) -> void:
	print(STR)
	match STR.to_lower():
		"cat":    _dia_handler(cat, wor)
		"nazi":   _dia_handler(nazi, wor)
		"painting":   _dia_handler(painting, wor)
		"candles":      _dia_handler(candles, wor)
		"symbol": _dia_handler(symbol, wor)

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
	if STR == cat or STR == nazi or STR == painting:
		match STR:
			cat:
				var arr = [STR, cat_2, cat_3, cat_4]
				new_dia.emit_signal("send_dia", arr)
				_spawn_goth(new_dia, false, false)
				return
			nazi:
				var arr = [STR, nazi_2, nazi_3, nazi_4]
				new_dia.emit_signal("send_dia", arr)
				_spawn_goth(new_dia, false, false)
				return
			painting:
				var arr = [STR, painting_2, painting_3]
				new_dia.emit_signal("send_dia", arr)
				_spawn_goth(new_dia, false, false)
				return

	# --- Single-line dialogues with old character ---
	#if  STR == guitar or STR == poster:
		#new_dia.emit_signal("send_dia", STR)
		#_spawn_goth(new_dia, true, true)
		#return

	new_dia.emit_signal("send_dia", STR)
	return


# ============================================================
# HELPERS
# ============================================================
func _spawn_goth(parent : dialogue_scene, visible : bool, speak : bool) -> void:
	var new_goth : CHARACTER = GOTH.instantiate()
	parent.add_child(new_goth)
	parent.emit_signal("add_character", visible)
	new_goth.visible = visible
	new_goth.emit_signal("set_speak", speak)
