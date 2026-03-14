extends Area2D
class_name GroundItem

@export var item_data: ItemData: set = _set_item_data
@export var quantity: int = 1

@onready var sprite: Sprite2D = $Sprite2D

func _set_item_data(value: ItemData) -> void:
	item_data = value
	# Await ready ensures $Sprite2D isn't null when spawning from code
	if not is_node_ready(): 
		await ready 
		
	if item_data:
		sprite.texture = item_data.icon

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			_pick_up()

func _pick_up() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.inventory:
		if player.inventory.add_item(item_data, quantity):
			player.message_system.show_message("Picked up " + str(quantity) + " " + item_data.name + "!")
			queue_free()
		else:
			player.message_system.show_message("inventory_full")
