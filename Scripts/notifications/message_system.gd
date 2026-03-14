extends CanvasLayer
class_name MessageSystem

@onready var message_label: Label = $MessageLabel
var message_tween: Tween

# Store all your game's messages here
const MESSAGES: Dictionary = {
	"inventory_full": "Inventory full! Make room.",
	"need_tool": "You need a tool to harvest this.",
	"craft_success": "Item successfully crafted!"
}

func _ready() -> void:
	if message_label:
		_setup_message_style()
		message_label.hide()

func show_message(message_id: String) -> void:
	if not message_label: return
	
	# Fetch the message from the dictionary, or use the raw string if not found
	var text_to_show = MESSAGES.get(message_id, message_id)
	
	message_label.text = text_to_show
	message_label.show()
	
	if message_tween and message_tween.is_valid():
		message_tween.kill()
		
	message_tween = create_tween()
	message_tween.tween_interval(3.0)
	message_tween.tween_callback(message_label.hide)

func _setup_message_style() -> void:
	message_label.add_theme_color_override("font_color", Color.WHITE)
	message_label.add_theme_font_size_override("font_size", 24)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.5)
	style.content_margin_left = 15
	style.content_margin_right = 15
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	message_label.add_theme_stylebox_override("normal", style)
	
	message_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	message_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	message_label.position.y = 20
