extends CharacterBody2D
class_name CHARACTER
const CHARACTER_SHADER = preload("uid://r0qfsecxyya7")

signal interact
signal set_speak(Value : bool)


var original_position : Vector2
var marker : Marker2D
var speaking : bool = false
var ID : String
var sprite : Sprite2D
var shader_node : Sprite2D
var DB : bool = true
var animation_player : AnimationPlayer


func _ready() -> void:
	original_position = position
	add_to_group("character")
	for child in get_children():
		if !child.is_in_group("object_sprite"): continue
		sprite = child
	ID = name.to_upper()
	marker = get_parent().find_child("dialogue_speaker_marker")
	animation_player = find_child("AnimationPlayer")
	_shader_creator()

func _init() -> void:
	visible = false
	set_speak.connect(_set_speak)
	interact.connect(_on_interact)

func _on_interact():
	print("Interacted with "+ID)
	_move()

func _set_speak():
	if (speaking): speaking = false; return
	if (!speaking): speaking = true; return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_shade()
		_on_interact()

func _shader_creator():
	var new_node : Sprite2D = Sprite2D.new()
	new_node.name = "SHADER"
	new_node.texture = sprite.texture
	
	add_child(new_node)
	var MATERIAL : ShaderMaterial = ShaderMaterial.new()
	MATERIAL.shader = CHARACTER_SHADER
	new_node.material = MATERIAL
	new_node.z_index += 1
	shader_node = new_node
	shader_node.visible = false

func _shade():
	if (!shader_node): return
	if (shader_node.visible): shader_node.visible = false; return
	if (!shader_node.visible): shader_node.visible = true; return

func _move():
	if (position != marker.position):position = marker.position
	visible = true
	animation_player.play("Wobble")
