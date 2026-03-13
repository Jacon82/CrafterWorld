extends Node2D

# This allows us to drag and drop our test_inventory.tres in the Inspector
@export var player_inventory: InventoryData

# This grabs a reference to the UI we dragged into the scene
@onready var inventory_ui: Control = $InventoryUI

func _ready() -> void:
	# When the game starts, hand the data to the UI
	if player_inventory != null:
		inventory_ui.set_inventory_data(player_inventory)
	else:
		print("Warning: No inventory data assigned to Main!")
