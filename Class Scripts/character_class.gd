extends CharacterBody2D
class_name CHARACTER
const CHARACTER_SHADER = preload("uid://r0qfsecxyya7")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

signal interact
signal set_speak(Value : bool)

var timer : Timer
var marker : Marker2D
var speaking : bool = false
var ID : String
var sprite : AnimatedSprite2D
var shader_node : Sprite2D
var DB : bool = true
var animation_player : AnimationPlayer


func _ready() -> void:
	if audio_stream_player_2d: audio_stream_player_2d.stop()
	scale = scale *4
	add_to_group("character")
	for child in get_children():
		if !child.is_in_group("object_sprite"): continue
		sprite = child
	timer = find_child("Timer")
	timer.timeout.connect(_change_sprite)
	ID = name.to_upper()
	marker = get_parent().find_child("dialogue_speaker_marker")
	animation_player = find_child("AnimationPlayer")

func _init() -> void:
	set_speak.connect(_set_speak)
	interact.connect(_on_interact)

func _on_interact():
	print("Interacted with "+ID)

func _set_speak(value : bool):
	#_move()
	if value: timer.autostart = true
	if value: if audio_stream_player_2d: audio_stream_player_2d.play()
	if value: timer.start(.4)
	if !value: timer.autostart = false
	if !value: if audio_stream_player_2d: audio_stream_player_2d.stop()
	if !value: timer.stop()
	speaking = value

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("ui_accept"): return
	_shade()
	_on_interact()

func _shade():
	if (!shader_node): return
	if (shader_node.visible): shader_node.visible = false; return
	if (!shader_node.visible): shader_node.visible = true; return

func _move():
	visible = true
	animation_player.play("character_animations/character_wobble")

func _change_sprite():
	if (sprite.frame == 3): sprite.frame = 2; return
	if (sprite.frame == 2): sprite.frame = 3; return
	sprite.frame = 3
	return
