class_name MAIN_OBJ_HANDLER

var granny_items = ["TEA_SET", "PHOTO", "WET_BOOK", "VASE_ASH", "PHOTO_BOOK"]
var teen_items = ["BED", "GUITAR","ROAD_SIGN", "GRAFFITI", "SKATEBOARD", "POSTER"]
var goth_items = ["CAT","CANDLES", "NAZI","PAINTING", "SYMBOL"]

func _interacted_with_object(STR : String, wor : Node2D):
	if granny_items.has(STR): _old(STR, wor)
	if teen_items.has(STR): _teen(STR, wor)
	if goth_items.has(STR): _goth(STR, wor)

func _old(object : String, wor : Node2D):
	var OOH : old_object_handler = old_object_handler.new()
	OOH._interacted_with(object, wor)

func _teen(object: String, wor : Node2D):
	var TOH : TEEN_OBJ_HANDLER = TEEN_OBJ_HANDLER.new()
	TOH._interacted_with(object, wor)

func _goth(object: String, wor : Node2D):
	var GOH : GOTH_OBJ_HANDLER = GOTH_OBJ_HANDLER.new()
	GOH._interacted_with(object, wor)
