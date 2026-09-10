extends Node2D
class_name Room

## Reference to the backgroun sprite/image of the room scene.
var background: Sprite2D
#@onready var background: Sprite2D = $Background

#var game_context: GameContext = null
var navigator: RoomNavigator = null

func _ready() -> void:
	assert(background != null, "Room is missing 'Background (Sprite2D)' node")
	
	# For all objects in this room, connect to the interaction signal.
	#for game_object in get_tree().get_nodes_in_group("game_object"):
		#if game_object.mouse_clicked:
			#game_object.mouse_clicked.connect(_on_object_interacted)


#func _on_object_interacted(_game_object) -> void:
	#game_object.in_game_interaction(game_context)

## Calculates a Rect2 for the visible area of the room's background, in global
## coordinates.
func get_background_visible_rect() -> Rect2:
	var size: Vector2 = background.texture.get_size() * background.scale
	
	# Assuming global_position is the center of the sprite, calculate
	# left-upper corner position.
	var origin: Vector2 = background.global_position - size / 2.0
	
	return Rect2(origin, size)

## Calculates the global position where the camera should be placed on entering
## this room.
func get_camera_spawn_position() -> Vector2:
	return get_background_visible_rect().get_center()
