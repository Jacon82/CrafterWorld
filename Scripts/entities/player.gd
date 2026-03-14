extends CharacterBody2D

@export var speed: float = 200.0
@export var inventory: InventoryData 

@onready var interact_zone: Area2D = $InteractZone
@onready var message_system: MessageSystem = $HUD

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	var direction_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction_vector * speed
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		swing_tool()

func swing_tool() -> void:
	var bodies_in_range = interact_zone.get_overlapping_bodies()
	
	for body in bodies_in_range:
		if body.has_method("take_damage"):
			var loot = body.take_damage(inventory)
			
			if loot.has("error") and loot["error"] == "inventory_full":
				# Just pass the dictionary ID now
				message_system.show_message("inventory_full")
			elif loot.has("item") and loot["item"] != null:
				inventory.add_item(loot["item"], loot["amount"])
