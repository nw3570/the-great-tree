extends PanelContainer
class_name OptionsMenu

@onready var _btn_container = $VBoxContainer

var _options: Dictionary[String, Button]
var _original_scale: Vector2

func _ready() -> void:
	_original_scale = scale
	pivot_offset = size / 2.0
	_btn_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func _create_option_button(label: String, icon: Texture2D = null) -> Button:
	var btn = Button.new()
	btn.text = label
	if icon: btn.icon = icon
	
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	return btn

func add_option(label: String, icon: Texture2D = null) -> bool:
	if _options.has(label):
		return false
	
	_options[label] = _create_option_button(label, icon)
	_btn_container.add_child(_options[label])
	return true

func get_option_button(label: String) -> Button:
	return _options[label]

func toggle() -> void:
	if visible:
		close()
	else:
		open()

func open() -> void:
	if visible:
		return
	
	scale = Vector2.ZERO
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	show()
	tween.tween_property(self, "scale", _original_scale, 0.3)
	await tween.finished
	

func close() -> void:
	if !visible:
		return
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	await tween.finished
	hide()
