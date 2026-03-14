extends StaticBody2D

@export var drop_item: ItemData
@export var drop_amount: int = 3
var health: int = 3

# This function will be called by the player
func take_damage() -> Dictionary:
	health -= 1
	
	if health <= 0:
		queue_free() # This deletes the tree from the world entirely
		return {"item": drop_item, "amount": drop_amount}
		
	return {} # Return an empty dictionary if the tree isn't dead yet
