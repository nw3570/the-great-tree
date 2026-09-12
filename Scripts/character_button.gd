extends TextureButton
class_name CharacterButton

@export var character: CHARACTER

func _ready() -> void:
	var character_frames = character.sprite.sprite_frames
	
	# "shut" texture is the button's normal texture.
	texture_normal = character_frames.get_frame_texture("default", 2)
	# "talking" texture is button's hover texture.
	texture_hover = character_frames.get_frame_texture("default", 3)
