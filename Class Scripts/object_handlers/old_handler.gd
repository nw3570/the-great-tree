extends MAIN_OBJ_HANDLER
class_name old_object_handler

# ============================================================
# PRELOADS
# ============================================================
const DIALOGUE_SCENE = preload("uid://cxgtxwadgcghp")
const OLD = preload("uid://4rdyi8de470a")

# ============================================================
# SIGNALS
# ============================================================
signal next_dialogue

# ============================================================
# DIALOGUE STRINGS
# ============================================================
var td : String  = "That looks quite fancy"
var wd : String  = "Why would The Book of All Seeds be so wet?"
var vd : String  = "That's where my Henry is… I miss him every day. Died from cancer, a bad one... One of life's unfortunate jest… But we gotta move on, dear."
var pd : String  = "That's my Henry's face… the day we married… we met? I don't want to forget his handsome features. Although, how things are going… that seems to be my fate."
var pbd : String = "I like seeing how my younglings used to play with me. People say that, sometimes, I don't quite act like myself. The book helps me remain in my place"
var wd2 : String = "Darling, I swear I'm not a heretic. I just had a little accident while I was praying. I would rather not expand upon that, hope you don't mind that, sweetie."

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
		"tea_set":    _dia_handler(td, wor)
		"wet_book":   _dia_handler(wd, wor)
		"vase_ash":   _dia_handler(vd, wor)
		"photo":      _dia_handler(pd, wor)
		"photo_book": _dia_handler(pbd, wor)

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
	if STR == wd:
		var arr = [STR, wd2]
		new_dia.emit_signal("send_dia", arr)
		print("Waited")
		_spawn_old_character(new_dia, false, false)
		return

	# --- Single-line dialogues with old character ---
	if STR == vd or STR == pd or STR == pbd:
		new_dia.emit_signal("send_dia", STR)
		_spawn_old_character(new_dia, true, true)
		return

	# --- Default: simple dialogue ---
	new_dia.emit_signal("send_dia", STR)

# ============================================================
# HELPERS
# ============================================================
func _spawn_old_character(parent : dialogue_scene, visible : bool, speak : bool) -> void:
	var new_old : CHARACTER = OLD.instantiate()
	parent.add_child(new_old)
	parent.emit_signal("add_character", visible)
	new_old.visible = visible
	new_old.emit_signal("set_speak", speak)
