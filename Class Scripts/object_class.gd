extends StaticBody2D
class_name OBJECT

const TEST_SHADER = preload("uid://10heid8b4wnb")

signal icon_found
signal mouse_clicked(object_id: String)

@export var tooltip_text: String = ""
@export var tooltip_offset: Vector2 = Vector2(0, -100)
var tooltip_label: Label

var guitar_centered: bool = false
var guitar_highlighted: bool = false
var guitar: bool = false

var original_scale: Vector2
var original_rotation: float
var original_position: Vector2

var sprite: Sprite2D
var selected: bool
var object_id: String


func _init() -> void:
	original_scale = scale
	await icon_found
	var new_area: Area2D = Area2D.new()
	add_child(new_area)
	new_area.add_child(generate_collision())
	new_area.mouse_entered.connect(_mouse_entered)
	new_area.mouse_exited.connect(_mouse_exited)


func _ready() -> void:
	original_position = position
	original_rotation = rotation
	original_scale = scale
	z_index = 2
	add_to_group("game_object")
	object_id = name.to_upper()

	for child in get_children():
		if child.is_in_group("object_sprite"):
			continue
		sprite = child
		emit_signal("icon_found")
		return


func _mouse_entered() -> void:
	selected = true
	# If the guitar is already zoomed in, don't re-apply highlight/move scaling
	if guitar_centered:
		_show_tooltip()
		return
	_highlight()
	_show_tooltip()
	move()


func _mouse_exited() -> void:
	selected = false
	# Don't reset anything while the guitar is zoomed in
	if guitar_centered:
		_hide_tooltip()
		return
	_un_highlight()
	_hide_tooltip()
	reset()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") and selected:
		var MOH: MAIN_OBJ_HANDLER = MAIN_OBJ_HANDLER.new()
		MOH._interacted_with_object(object_id, get_parent())
		emit_signal("mouse_clicked", object_id)

		if object_id == "GUITAR":
			if guitar:
				return
			guitar = true
			# Capture the actual pre-zoom position at click time
			original_position = position
			if name.to_upper() == "GUITAR":
				scale = scale * 2
				guitar_centered = true
				position = get_viewport_rect().get_center()
				position.y -= 100

	elif event.is_action_pressed("LMB") and not selected and guitar_centered:
		guitar_centered = false
		# Restore position BEFORE clearing the guitar flag
		position = original_position
		guitar = false
		_un_highlight()
		reset()


func _show_tooltip() -> void:
	if tooltip_text.is_empty():
		return
	if not tooltip_label:
		tooltip_label = Label.new()
		tooltip_label.name = "TOOLTIP"
		tooltip_label.z_index = 100
		add_child(tooltip_label)
	tooltip_label.text = tooltip_text
	tooltip_label.scale = scale
	tooltip_label.z_index = 1
	tooltip_label.position = Vector2(sprite.scale.x, (sprite.texture.get_size().y) * -0.8)


func _hide_tooltip() -> void:
	pass


func _un_highlight() -> void:
	var highlight_node: Sprite2D
	for child in get_children():
		if child.name != "HIGHLIGHT":
			continue
		highlight_node = child
	if not highlight_node:
		return
	highlight_node.queue_free()
	guitar_highlighted = false


func _highlight() -> void:
	# Only one highlight at a time
	if guitar_highlighted:
		return
	guitar_highlighted = true

	var highlight_node: Sprite2D = Sprite2D.new()
	highlight_node.name = "HIGHLIGHT"
	highlight_node.texture = sprite.texture
	add_child(highlight_node)

	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = TEST_SHADER
	highlight_node.material = material
	highlight_node.scale = highlight_node.scale * 1.05
	highlight_node.z_index -= 1


func move() -> void:
	# Never re-scale the guitar while it's zoomed in
	if guitar_centered:
		return

	original_rotation = rotation
	original_scale = scale

	var randomizer: RandomNumberGenerator = RandomNumberGenerator.new()
	var ran_rot: int = randomizer.randi_range(-10, 10)
	var ran_scaler: float = randomizer.randf_range(1.05, 1.2)
	rotation_degrees += ran_rot
	scale = scale * ran_scaler


func reset() -> void:
	# Do nothing if the guitar is currently zoomed in
	if guitar_centered:
		return
	rotation = original_rotation
	scale = original_scale


func generate_collision() -> CollisionPolygon2D:
	var image = sprite.texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)

	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, image.get_size()))

	if polygons.size() > 0:
		var collision = CollisionPolygon2D.new()
		collision.polygon = polygons[0]
		collision.scale = sprite.scale
		collision.position = (collision.position - sprite.texture.get_size()) / 2
		return collision
	return null
