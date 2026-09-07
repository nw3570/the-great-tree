extends Node2D

func _ready() -> void:
	_connect_objects()

# Here it connects all the objects for the interaction
# The all OBJECTS emit a signal when clicked, this connects the signal to a function
func _connect_objects():
	for child in get_children():
		if !child.is_in_group("game_object"): continue
		var obj : OBJECT = child
		obj.mouse_clicked.connect(_object_clicked)

# The object ID is whatever the objects name is
# The name is automatically converted to uppercase because of the class

func _object_clicked(object_id : String): 
	print("Interacted with "+object_id)
	# Interaction code
