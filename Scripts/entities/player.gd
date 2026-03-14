extends CharacterBody2D

@export var speed: float = 200.0
@export var inventory: InventoryData # Give the player their own inventory slot!

@onready var interact_zone: Area2D = $InteractZone

func _physics_process(_delta: float) -> void:
	var direction_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction_vector * speed
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		swing_tool()

func swing_tool() -> void:
	# Grab every physics body currently inside our Area2D circle
	var bodies_in_range = interact_zone.get_overlapping_bodies()
	
	# Print exactly what the Area2D sees to the Output log
	print("I swung my tool! I hit: ", bodies_in_range)
	
	for body in bodies_in_range:
		# Check if the object we are touching has the take_damage function
		if body.has_method("take_damage"):
			var loot = body.take_damage()
			
			# If the tree died and gave us a dictionary with items, add them!
			if loot.has("item") and loot["item"] != null:
				inventory.add_item(loot["item"], loot["amount"])
