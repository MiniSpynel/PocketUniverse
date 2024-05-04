extends ModuleClass

var wallDictionary : Dictionary = {}

@export_category("Walls")
@export var wallFront: PackedScene
@export var wallBack: PackedScene
@export var wallLeft: PackedScene
@export var wallRight: PackedScene
@export var wallUp: PackedScene
@export var wallDown: PackedScene

@onready var base: Node3D = $".."

@export_category("Neighouring modules")
@export var NeighbourFront: Node3D
@export var NeighbourBack: Node3D
@export var NeighbourLeft: Node3D
@export var NeighbourRight: Node3D
@export var NeighbourUp: Node3D
@export var NeighbourDown: Node3D

func update_wall(name: String, object: PackedScene):
	wallDictionary[name]["object"].queue_free()
	wallDictionary[name]["object"] = object.instantiate()
	add_child(wallDictionary[name]["object"])
	wallDictionary[name].position = wallDictionary[name]["position"]
	wallDictionary[name].rotation = wallDictionary[name]["rotation"]


# Called when the node enters the scene tree for the first time.
func _ready():
	
	wallDictionary = {
		"wallF": {
					"object": wallFront.instantiate(),
					"position": Vector3(position.x, position.y, position.z+(dimensionX/2)-(wall_thickness/2)),
					"rotation": Vector3(0, 0, 0),
					"direction": Vector3(0, 0, dimensionZ/2)
				},
		"wallB": {
					"object": wallBack.instantiate(),
					"position": Vector3(position.x, position.y, position.z-(dimensionX/2)+(wall_thickness/2)),
					"rotation": Vector3(0, 0, 0),
					"direction": Vector3(0, 0, -dimensionZ/2)
				},
		"wallL": {
					"object": wallLeft.instantiate(),
					"position": Vector3(position.x-(dimensionZ/2)+(wall_thickness/2), position.y, position.z),
					"rotation": Vector3(0, 90*PI/180, 0),
					"direction": Vector3(-dimensionX/2, 0, 0)
				},
		"wallR": {
					"object": wallRight.instantiate(),
					"position": Vector3(position.x+(dimensionZ/2)-(wall_thickness/2), position.y, position.z),
					"rotation": Vector3(0, 90*PI/180, 0),
					"direction": Vector3(dimensionX/2, 0, 0)
				},
		"wallU": {
					"object": wallUp.instantiate(),
					"position": Vector3(position.x, position.y+(dimensionY/2)-(wall_thickness/2), position.z),
					"rotation": Vector3(90*PI/180, 0, 0),
					"direction": Vector3(0, dimensionY/2, 0)
				},
		"wallD": {
					"object": wallDown.instantiate(),
					"position": Vector3(position.x, position.y-(dimensionY/2)+(wall_thickness/2), position.z),
					"rotation": Vector3(90*PI/180, 0, 0),
					"direction": Vector3(0, -dimensionY/2, 0)
				},
	}

	for wall in wallDictionary:
		wallDictionary[wall]["object"].set_script( load("res://Scripts/Wall.gd") )
		wallDictionary[wall]["object"].Room = self
		wallDictionary[wall]["object"].base = base
		add_child(wallDictionary[wall]["object"])
		wallDictionary[wall]["object"].position = wallDictionary[wall]["position"]
		wallDictionary[wall]["object"].rotation = wallDictionary[wall]["rotation"]
		wallDictionary[wall]["object"].newRoomDirection = wallDictionary[wall]["direction"]
	
	base.BaseGrid[Vector3(position.x, position.y, position.z)] = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
