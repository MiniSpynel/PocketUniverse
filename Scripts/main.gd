extends Node

@onready var player = $Player
@onready var inventory = $UI/InventoryInterface

func _ready():
	inventory.set_player_inventory_data(player.inventory_data)
	player.toggle_inventory.connect(toggle_inventory_interface)
	
func toggle_inventory_interface():
	inventory.visible = !inventory.visible
	
	if inventory.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
