extends Control

const SLOT_UI_SCENE = preload("res://scenes/ui/slot_ui.tscn")

@onready var item_grid: GridContainer = $PanelContainer/MarginContainer/ItemGrid

# We will pass our data into this function
func set_inventory_data(inventory_data: InventoryData) -> void:
	# First, clear any existing placeholder slots in the grid
	for child in item_grid.get_children():
		child.queue_free()
		
	# Generate a visual slot for every piece of data
	for slot_data in inventory_data.slots:
		var slot_ui = SLOT_UI_SCENE.instantiate()
		item_grid.add_child(slot_ui)
		slot_ui.set_slot_data(slot_data)
