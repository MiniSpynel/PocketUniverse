extends Node

@onready var player = $Player
@onready var UI = $UI
@onready var inventory = UI.inventoryMenu
@onready var menu = UI.menu
@onready var buildMenu = UI.buildMenu

var cameraMove = true

func _ready():
	inventory.set_player_inventory_data(player.inventory_data)
	menu.resume.connect(toggle_menu)
	player.toggle_menu.connect(toggle_menu)
	player.toggle_build_menu.connect(toggle_build_interface)
	player.toggle_inventory.connect(toggle_inventory_interface)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func toggle_menu():
	menu.visible = !menu.visible
	cameraMove = !cameraMove
	if menu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func toggle_build_interface():
	buildMenu.visible = !buildMenu.visible
	cameraMove = !cameraMove
	if buildMenu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func toggle_inventory_interface():
	inventory.visible = !inventory.visible
	cameraMove = !cameraMove
	if inventory.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
