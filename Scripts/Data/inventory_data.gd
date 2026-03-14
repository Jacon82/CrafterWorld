extends Resource
class_name InventoryData

signal inventory_updated

@export var slots: Array[SlotData]

# A helper function to easily grab an item from the world
func add_item(item: ItemData, amount: int) -> bool:
	for slot in slots:
		if slot.item_data == item and slot.quantity < item.max_stack_size:
			var space_left = item.max_stack_size - slot.quantity
			if amount <= space_left:
				slot.quantity += amount
				inventory_updated.emit() # ADD THIS LINE
				return true
			else:
				slot.quantity += space_left
				amount -= space_left
				
	for slot in slots:
		if slot.item_data == null:
			slot.item_data = item
			slot.quantity = amount
			inventory_updated.emit() # ADD THIS LINE
			return true
			
	return false
