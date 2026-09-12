extends Node2D
class_name Room

## Reference to the backgroun sprite/image of the room scene.
@export var background: Sprite2D
#@onready var background: Sprite2D = $Background

#var game_context: GameContext
#var navigator: Navigator

func _ready() -> void:
	assert(background != null, "Room is missing 'Background (Sprite2D)' node")

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
