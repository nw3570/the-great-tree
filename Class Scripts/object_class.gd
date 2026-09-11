extends StaticBody2D
class_name OBJECT

const TEST_SHADER = preload("uid://10heid8b4wnb")

signal icon_found
signal mouse_clicked(object_id : String)

@export var tooltip_text : String = ""
@export var tooltip_offset : Vector2 = Vector2(0, -100)
var tooltip_label : Label

var original_scale : Vector2
var sprite : Sprite2D
var selected : bool
var object_id : String
var original_rotation

func _ready() -> void:
	tooltip_text = "TOOL TIP"
	add_to_group("game_object")
	object_id = name
	object_id = object_id.to_upper()
	for child in get_children():
		if child.is_in_group("object_sprite"): continue
		sprite = child
		emit_signal("icon_found")
		return

func _init() -> void:
	original_scale = scale
	await icon_found
	var new_area : Area2D = Area2D.new()
	#shape.size = sprite.texture.get_size()
	#new_collision.shape = shape
	add_child(new_area)
	new_area.add_child(generate_collision())
	new_area.mouse_entered.connect(_mouse_entered)
	new_area.mouse_exited.connect(_mouse_exited)

func _mouse_entered():
	selected = true
	_highlight()
	_show_tooltip()
	move()

func _mouse_exited():
	selected = false
	_un_highlight()
	_hide_tooltip()
	reset()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB") && selected):
		emit_signal("mouse_clicked", object_id)

func _show_tooltip():
	if tooltip_text.is_empty():
		return
	if !tooltip_label:
		tooltip_label = Label.new()
		tooltip_label.name = "TOOLTIP"
		tooltip_label.z_index = 100
		
		add_child(tooltip_label)
	tooltip_label.text = tooltip_text
	tooltip_label.scale = scale
	tooltip_label.z_index = 1
	tooltip_label.position = Vector2(sprite.scale.x, ((sprite.texture.get_size().y ))*-.8)

func _hide_tooltip():
	pass
	#if tooltip_label:
		#tooltip_label.queue_free()
		#tooltip_label = null

func _un_highlight():
	var highlight_node : Sprite2D
	for child in get_children():
		if(child.name != "HIGHLIGHT"): continue
		highlight_node = child
	if !highlight_node: print("not_found"); return
	highlight_node.queue_free()

func _highlight():
	var highlight_node : Sprite2D = Sprite2D.new()
	highlight_node.name = "HIGHLIGHT"
	highlight_node.texture = sprite.texture
	add_child(highlight_node)
	var MATERIAL : ShaderMaterial = ShaderMaterial.new()
	MATERIAL.shader = TEST_SHADER
	highlight_node.material = MATERIAL

	highlight_node.scale = highlight_node.scale * 1.05
	highlight_node.z_index -= 1

func move():
	original_rotation = rotation
	original_scale = scale

	var Randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	var ran_rot : int = Randomizer.randi_range(-10,10)
	var ran_scaler : float = Randomizer.randf_range(1.05, 1.2)
	rotation_degrees = rotation_degrees + ran_rot
	scale = scale * ran_scaler

func reset():
	rotation = original_rotation
	scale = original_scale

func generate_collision():
	var image = sprite.texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)

	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, image.get_size()))
	
	if polygons.size() > 0:
		var collision = CollisionPolygon2D.new()
		collision.polygon = polygons[0]
		collision.position = (collision.position - sprite.texture.get_size())/2
		return(collision)
