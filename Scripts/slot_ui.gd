extends PanelContainer

@onready var item_icon: TextureRect = $ItemIcon
@onready var quantity_label: Label = $QuantityLabel

func set_slot_data(slot_data: SlotData) -> void:
	if slot_data == null or slot_data.item_data == null:
		# If the slot is empty, hide the icon and text
		item_icon.texture = null
		item_icon.hide()
		quantity_label.hide()
		return
		
	# If there is an item, show its icon and quantity
	item_icon.texture = slot_data.item_data.icon
	item_icon.show()
	
	if slot_data.quantity > 1:
		quantity_label.text = str(slot_data.quantity)
		quantity_label.show()
	else:
		# Hide the number if we only have 1 of the item
		quantity_label.hide()
