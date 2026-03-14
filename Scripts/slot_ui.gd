extends PanelContainer

@onready var item_icon: TextureRect = $ItemIcon
@onready var quantity_label: Label = $QuantityLabel

var current_slot_data: SlotData
var is_dragging: bool = false

const GROUND_ITEM_SCENE = preload("res://scenes/entities/ground_item.tscn")

func set_slot_data(slot_data: SlotData) -> void:
	current_slot_data = slot_data
	
	if slot_data == null or slot_data.item_data == null:
		item_icon.texture = null
		item_icon.hide()
		quantity_label.hide()
		return
		
	item_icon.texture = slot_data.item_data.icon
	item_icon.show()
	
	if slot_data.quantity > 1:
		quantity_label.text = str(slot_data.quantity)
		quantity_label.show()
	else:
		quantity_label.hide()

# 1. Triggers when you click and drag the slot
func _get_drag_data(_at_position: Vector2) -> Variant:
	if current_slot_data == null or current_slot_data.item_data == null:
		return null
		
	# Create a visual preview of the icon following your mouse
	var preview = TextureRect.new()
	preview.texture = current_slot_data.item_data.icon
	preview.custom_minimum_size = Vector2(32, 32)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	set_drag_preview(preview)
	
	is_dragging = true
	return current_slot_data

# 2. Listens for the end of the drag event
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		# If the drag ended and wasn't dropped into a valid UI element, toss it into the world
		if is_dragging and not is_drag_successful():
			_drop_item_in_world()
		is_dragging = false

# 3. Spawns the physical item
func _drop_item_in_world() -> void:
	var world = get_tree().current_scene
	var drop_pos = world.get_global_mouse_position()
	
	var ground_item = GROUND_ITEM_SCENE.instantiate()
	ground_item.item_data = current_slot_data.item_data
	ground_item.quantity = current_slot_data.quantity
	ground_item.global_position = drop_pos
	
	world.add_child(ground_item)
	
	# Clear the item from the inventory and force this specific UI slot to visually update
	current_slot_data.quantity = 0 
	set_slot_data(current_slot_data)
