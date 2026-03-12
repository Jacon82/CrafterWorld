extends Resource
class_name InventoryData

@export var slots: Array[SlotData]

# A helper function to easily grab an item from the world
func add_item(item: ItemData, amount: int) -> bool:
	# First pass: try to add to an existing stack of the same item
	for slot in slots:
		if slot.item_data == item and slot.quantity < item.max_stack_size:
			var space_left = item.max_stack_size - slot.quantity
			if amount <= space_left:
				slot.quantity += amount
				return true
			else:
				slot.quantity += space_left
				amount -= space_left
				
	# Second pass: if we still have items, find an empty slot
	for slot in slots:
		if slot.item_data == null:
			slot.item_data = item
			slot.quantity = amount
			return true
			
	# If the inventory is completely full
	return false
