extends Camera2D

# Margin used to detect if the mouse pointer is on an edge of the screen, in
# pixels.
@export var edge_margin := 100.0

# Speed which the camera will move, in pixels/sec.
@export var pan_speed := 500.0

# Extra distance the camera is allowed to move beyond the limits before being
# clamped, for horizontal and vertical directions, in pixels.
# 0 means the camera stops exactly when the screen's edge touches the 
# limits. Increasing the value will give the camera some breathing 
# room, if there is padding or fallback art around the limits.
@export var pan_range := Vector2.ZERO

# Minimum and maximum positions the camera's center (global_position) can go to.
# Must be defined for the _process method to work, in world pixels.
var min_position: Vector2
var max_position: Vector2

#func _ready() -> void:
	#pan_range = Vector2(100.0, 100.0)
	#set_bounds(Vector2(1150, 660)) # <--- Test for corridor image

# Updates the camera position based on the mouse position near the border of the
# screen.
func _process(delta: float) -> void:
	var pan_direction = pan_direction_from_mouse_position()	
	
	global_position += pan_speed * pan_direction.normalized() * delta
	global_position = global_position.clamp(min_position, max_position)

# Sets min_position and max_positon based on a background's dimensions and
# origin, given that the origin is the background's left upper corner.
#
# Intended use is to readjust the camera movement to different environment 
# scenes that might have different dimensions or visible portions.
func set_bounds(bg_size: Vector2, bg_origin: Vector2 = Vector2.ZERO) -> void:
	# Since the camera's global_position is at the center of the screen, this is
	# the distance from its center to each screen edge. It is used to calculate
	# how close the camera's center can get to the background's edges without
	# showing anything outside of it.
	var half_visible_area: Vector2 = (get_viewport().get_visible_rect().size / zoom) / 2.0
	
	# Limits for the camera's center, keeping the visible screen inside the
	# background. pan_range expands these limits by the given amount, so the
	# camera can move more freely.
	min_position = bg_origin + half_visible_area - pan_range
	max_position = bg_origin + bg_size - half_visible_area + pan_range

# Calculates the direction vector for the camera movement, based on the current
# mouse position and edge_margin. 
#
# If the mouse is in the area near the borders defined by edge_margin, the
# camera should move in the mouse's direction.
func pan_direction_from_mouse_position() -> Vector2:
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()	
	var direction = Vector2.ZERO
	
	if mouse_pos.x <= edge_margin:
		direction.x = -1
	elif mouse_pos.x >= viewport_size.x - edge_margin:
		direction.x = 1
	
	if mouse_pos.y <= edge_margin:
		direction.y = -1
	elif mouse_pos.y >= viewport_size.y - edge_margin:
		direction.y = 1
	
	return direction
