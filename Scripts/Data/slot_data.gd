extends Resource
class_name SlotData

@export var item_data: ItemData
@export var quantity: int = 0: set = set_quantity

# This setter function automatically runs anytime the quantity changes
func set_quantity(value: int) -> void:
	quantity = value
	
	# If the slot is empty, ensure quantity is 0
	if not item_data:
		quantity = 0
		return
		
	# Clamp the quantity so it cannot exceed the item's max stack
	if quantity > item_data.max_stack_size:
		quantity = item_data.max_stack_size
		
	# If quantity drops to 0 or below, clear the item from the slot
	if quantity <= 0:
		item_data = null
		quantity = 0
