class_name MAIN_OBJ_HANDLER

var granny_items = ["TEA_SET", "PHOTO", "WET_BOOK", "VASE_ASH", "PHOTO_BOOK"]

func _interacted_with_object(STR : String, wor : Node2D):
	if granny_items.has(STR): _old(STR, wor)

func _old(object : String, wor : Node2D):
	var OOH : old_object_handler = old_object_handler.new()
	OOH._interacted_with(object, wor)
