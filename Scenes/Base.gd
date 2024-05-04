extends Node3D

var BaseGrid: Dictionary = {}
var dimensionX = load("res://Scripts/ModuleClass.gd").new().dimensionX
var dimensionY = load("res://Scripts/ModuleClass.gd").new().dimensionY
var dimensionZ = load("res://Scripts/ModuleClass.gd").new().dimensionZ

var room = load("res://Scenes/Module.tscn")
var door = load("res://Assets/Blender/door.blend")

func clear_walls():
	
	for key in BaseGrid:
		if BaseGrid.has(Vector3(key.x+dimensionX/2, key.y, key.z)):
			BaseGrid[key].update_wall("wallR", door)
			BaseGrid[Vector3(key.x+dimensionX/2, key.y, key.z)].update_wall("wallL", door)
		if BaseGrid.has(Vector3(key.x, key.y+dimensionY/2, key.z)):
			BaseGrid[key].update_wall("wallU", door)
			BaseGrid[Vector3(key.x, key.y+dimensionY/2, key.z)].update_wall("wallD", door)
		if BaseGrid.has(Vector3(key.x, key.y, key.z+dimensionZ/2)):
			BaseGrid[key].update_wall("wallF", door)
			BaseGrid[Vector3(key.x, key.y, key.z+dimensionZ/2)].update_wall("wallB", door)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_room = room.instantiate()
	new_room.position = Vector3(0, 0, 0)
	get_tree().root.get_node("World/GlobalBase").add_child(new_room)
	clear_walls()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
