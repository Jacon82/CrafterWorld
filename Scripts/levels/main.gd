extends Node2D

@export var player_inventory: InventoryData
@onready var inventory_ui: Control = $CanvasLayer/InventoryUI

# --- Procedural Generation Variables ---
@onready var tile_map: TileMapLayer = $TileMapLayer

@export var map_width: int = 50  # Width in tiles
@export var map_height: int = 50 # Height in tiles
@export var noise_scale: float = 3.0 # How "zoomed in" the noise is
@export var tree_scene: PackedScene
@export var tree_density: float = 0.05 # 5% chance to spawn a tree on a land tile

func _ready() -> void:
	# Initialize the UI
	if player_inventory != null:
		inventory_ui.set_inventory_data(player_inventory)
		
	# Generate the world!
	generate_island()

func generate_island() -> void:
	var noise = FastNoiseLite.new()
	noise.seed = randi() 
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	
	var half_width = int(map_width / 2.0)
	var half_height = int(map_height / 2.0)
	var max_radius = min(map_width, map_height) / 2.0
	
	for x in range(-half_width, half_width):
		for y in range(-half_height, half_height):
			var noise_val = noise.get_noise_2d(x * noise_scale, y * noise_scale)
			var distance_to_center = Vector2(x, y).distance_to(Vector2.ZERO)
			var distance_ratio = distance_to_center / max_radius
			var final_val = noise_val - (distance_ratio * 1.5)
			
			if final_val > -0.2:
				# 1. Place the grass tile
				tile_map.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
				
				# 2. Roll the dice to see if a tree grows here!
				if randf() < tree_density:
					spawn_tree(Vector2i(x, y))
			else:
				tile_map.erase_cell(Vector2i(x, y))

# Add this brand new helper function at the bottom of your script
func spawn_tree(grid_pos: Vector2i) -> void:
	if tree_scene == null:
		return # Safety check in case we forget to assign the scene
		
	var tree = tree_scene.instantiate()
	
	# map_to_local converts the grid coordinate (e.g., tile 5, 5) 
	# into exact screen pixels (e.g., pixel 320, 320) so the tree aligns with the world
	tree.position = tile_map.map_to_local(grid_pos)
	
	# Add the tree to the Main scene
	add_child(tree)
