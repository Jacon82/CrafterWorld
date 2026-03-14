extends Control
const SLOT_UI_SCENE = preload("res://scenes/ui/slot_ui.tscn")
@onready var item_grid: GridContainer = $PanelContainer/MarginContainer/ItemGrid
var current_inventory: InventoryData # Keep track of our data

func set_inventory_data(inventory_data: InventoryData) -> void:
	current_inventory = inventory_data
	
	# Connect the signal so it triggers the refresh function
	if not current_inventory.inventory_updated.is_connected(refresh_ui):
		current_inventory.inventory_updated.connect(refresh_ui)
		
	refresh_ui()

func refresh_ui() -> void:
	for child in item_grid.get_children():
		child.queue_free()
		
	for slot_data in current_inventory.slots:
		var slot_ui = SLOT_UI_SCENE.instantiate()
		item_grid.add_child(slot_ui)
		slot_ui.set_slot_data(slot_data)
