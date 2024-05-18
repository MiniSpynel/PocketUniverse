extends Node3D

var BaseGrid: Dictionary = {}
var dimension = load("res://Scripts/Module.gd").new().dimension

var room = load("res://Scenes/Module.tscn")

func clear_walls():
	
	for key in BaseGrid:
		# Deleting unnecessary walls
		if BaseGrid.has(Vector3(key.x+dimension, key.y, key.z)):
			BaseGrid[key].update_wall("wallR")
			BaseGrid[Vector3(key.x+dimension, key.y, key.z)].update_wall("wallL")
		if BaseGrid.has(Vector3(key.x, key.y+dimension, key.z)):
			BaseGrid[key].update_wall("wallU")
			BaseGrid[Vector3(key.x, key.y+dimension, key.z)].update_wall("wallD")
		if BaseGrid.has(Vector3(key.x, key.y, key.z+dimension)):
			BaseGrid[key].update_wall("wallF")
			BaseGrid[Vector3(key.x, key.y, key.z+dimension)].update_wall("wallB")
		
		# Deleting unecessary edges
		if BaseGrid.has(Vector3(key.x, key.y, key.z+dimension)) and BaseGrid.has(Vector3(key.x, key.y+dimension, key.z)) and BaseGrid.has(Vector3(key.x, key.y+dimension, key.z+dimension)):
			BaseGrid[key].update_edge("edgeFU")
			BaseGrid[Vector3(key.x, key.y, key.z+dimension)].update_edge("edgeBU")
			BaseGrid[Vector3(key.x, key.y+dimension, key.z)].update_edge("edgeFD")
			BaseGrid[Vector3(key.x, key.y+dimension, key.z+dimension)].update_edge("edgeBD")
		if BaseGrid.has(Vector3(key.x+dimension, key.y, key.z)) and BaseGrid.has(Vector3(key.x, key.y+dimension, key.z)) and BaseGrid.has(Vector3(key.x+dimension, key.y+dimension, key.z)):
			BaseGrid[key].update_edge("edgeRU")
			BaseGrid[Vector3(key.x+dimension, key.y, key.z)].update_edge("edgeLU")
			BaseGrid[Vector3(key.x, key.y+dimension, key.z)].update_edge("edgeRD")
			BaseGrid[Vector3(key.x+dimension, key.y+dimension, key.z)].update_edge("edgeLD")
		if BaseGrid.has(Vector3(key.x+dimension, key.y, key.z)) and BaseGrid.has(Vector3(key.x, key.y, key.z+dimension)) and BaseGrid.has(Vector3(key.x+dimension, key.y, key.z+dimension)):
			BaseGrid[key].update_edge("edgeFR")
			BaseGrid[Vector3(key.x+dimension, key.y, key.z)].update_edge("edgeFL")
			BaseGrid[Vector3(key.x, key.y, key.z+dimension)].update_edge("edgeBR")
			BaseGrid[Vector3(key.x+dimension, key.y, key.z+dimension)].update_edge("edgeBL")
			
		if BaseGrid.has(Vector3(key.x+dimension, key.y, key.z)) and BaseGrid.has(Vector3(key.x, key.y, key.z+dimension)) and BaseGrid.has(Vector3(key.x+dimension, key.y, key.z+dimension)) and BaseGrid.has(Vector3(key.x, key.y+dimension, key.z)) and BaseGrid.has(Vector3(key.x+dimension, key.y+dimension, key.z)) and BaseGrid.has(Vector3(key.x, key.y+dimension, key.z+dimension)) and BaseGrid.has(Vector3(key.x+dimension, key.y+dimension, key.z+dimension)):
			BaseGrid[key].update_corner("cornerFRU")
			BaseGrid[Vector3(key.x+dimension, key.y, key.z)].update_corner("cornerFLU")
			BaseGrid[Vector3(key.x, key.y, key.z+dimension)].update_corner("cornerBRU")
			BaseGrid[Vector3(key.x+dimension, key.y, key.z+dimension)].update_corner("cornerBLU")
			
			BaseGrid[Vector3(key.x, key.y+dimension, key.z)].update_corner("cornerFRD")
			BaseGrid[Vector3(key.x+dimension, key.y+dimension, key.z)].update_corner("cornerFLD")
			BaseGrid[Vector3(key.x, key.y+dimension, key.z+dimension)].update_corner("cornerBRD")
			BaseGrid[Vector3(key.x+dimension, key.y+dimension, key.z+dimension)].update_corner("cornerBLD")

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_room = room.instantiate()
	new_room.position = Vector3(0, 0, 0)
	get_tree().root.get_node("World/GlobalBase").add_child(new_room)
	clear_walls()


