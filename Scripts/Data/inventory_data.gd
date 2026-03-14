extends Resource
class_name InventoryData

signal inventory_updated

@export var slots: Array[SlotData]

# A helper function to easily grab an item from the world
func add_item(item: ItemData, amount: int) -> bool:
	# 1. Auto-initialize any null slots in case they were left empty in the Inspector
	for i in range(slots.size()):
		if slots[i] == null:
			slots[i] = SlotData.new()
			
	# 2. First pass: Try to fill up existing stacks
	for slot in slots:
		if slot.item_data == item and slot.quantity < item.max_stack_size:
			var space_left = item.max_stack_size - slot.quantity
			if amount <= space_left:
				slot.quantity += amount
				inventory_updated.emit()
				return true
			else:
				slot.quantity += space_left
				amount -= space_left
				
	# 3. Second pass: Put any remaining items into empty slots
	for slot in slots:
		if slot.item_data == null:
			slot.item_data = item
			
			# If the amount fits in one empty slot
			if amount <= item.max_stack_size:
				slot.quantity = amount
				inventory_updated.emit()
				return true
			else:
				# If we picked up a huge amount, fill this slot and keep looping
				slot.quantity = item.max_stack_size
				amount -= item.max_stack_size
				
	# 4. If we reach here, the inventory is full but we may have added partial items
	inventory_updated.emit()
	return false

func has_space_for(item: ItemData, amount: int) -> bool:
	var available_space: int = 0
	
	for i in range(slots.size()):
		var slot = slots[i]
		# If the slot is empty or hasn't been initialized
		if slot == null or slot.item_data == null:
			available_space += item.max_stack_size
		# If it has the matching item, check how much room is left
		elif slot.item_data == item:
			available_space += (item.max_stack_size - slot.quantity)
			
	return available_space >= amount
