extends StaticBody2D

@export var drop_item: ItemData
@export var drop_amount: int = 3
var health: int = 3

# We now pass the inventory in so the tree can verify space
func take_damage(inventory: InventoryData) -> Dictionary:
	# If this is the final hit, verify space before breaking the tree
	if health == 1:
		if not inventory.has_space_for(drop_item, drop_amount):
			return {"error": "inventory_full"}
			
	health -= 1
	
	if health <= 0:
		queue_free()
		return {"item": drop_item, "amount": drop_amount}
		
	return {}
