extends ModuleClass

var wallDictionary : Dictionary = {}
var edgeDictionary : Dictionary = {}

@export_category("Walls")
@export var wallFront: PackedScene
@export var wallBack: PackedScene
@export var wallLeft: PackedScene
@export var wallRight: PackedScene
@export var wallUp: PackedScene
@export var wallDown: PackedScene
@export var edge: PackedScene

@onready var base: Node3D = $".."

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
					"position": Vector3(0, 0, (dimensionZ/2)-(wall_thickness/2)),
					"rotation": Vector3(0, 0, 0),
					"direction": Vector3(0, 0, dimensionZ)
				},
		"wallB": {
					"object": wallBack.instantiate(),
					"position": Vector3(0, 0, -(dimensionZ/2)+(wall_thickness/2)),
					"rotation": Vector3(0, 0, 0),
					"direction": Vector3(0, 0, -dimensionZ)
				},
		"wallL": {
					"object": wallLeft.instantiate(),
					"position": Vector3(-(dimensionX/2)+(wall_thickness/2), 0, 0),
					"rotation": Vector3(0, 90*PI/180, 0),
					"direction": Vector3(-dimensionX, 0, 0)
				},
		"wallR": {
					"object": wallRight.instantiate(),
					"position": Vector3((dimensionX/2)-(wall_thickness/2), 0, 0),
					"rotation": Vector3(0, 90*PI/180, 0),
					"direction": Vector3(dimensionX, 0, 0)
				},
		"wallU": {
					"object": wallUp.instantiate(),
					"position": Vector3(0, (dimensionY/2)-(wall_thickness/2), 0),
					"rotation": Vector3(90*PI/180, 0, 0),
					"direction": Vector3(0, dimensionY, 0)
				},
		"wallD": {
					"object": wallDown.instantiate(),
					"position": Vector3(0, -(dimensionY/2)+(wall_thickness/2), 0),
					"rotation": Vector3(90*PI/180, 0, 0),
					"direction": Vector3(0, -dimensionY, 0)
				},
	}
	edgeDictionary = {
		"edgeFU": {
					"object": edge.instantiate(),
					"position": Vector3(0, (dimensionY/2)-(wall_thickness/2), (dimensionZ/2)-(wall_thickness/2)),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
		"edgeFL": {
					"object": edge.instantiate(),
					"position": Vector3(-(dimensionY/2)+(wall_thickness/2), 0, (dimensionZ/2)-(wall_thickness/2)),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeFR": {
					"object": edge.instantiate(),
					"position": Vector3((dimensionY/2)-(wall_thickness/2), 0, (dimensionZ/2)-(wall_thickness/2)),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeFD": {
					"object": edge.instantiate(),
					"position": Vector3(0, -(dimensionY/2)+(wall_thickness/2), (dimensionZ/2)-(wall_thickness/2)),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
				
		"edgeBU": {
					"object": edge.instantiate(),
					"position": Vector3(0, (dimensionY/2)-(wall_thickness/2), -(dimensionZ/2)+(wall_thickness/2)),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
		"edgeBL": {
					"object": edge.instantiate(),
					"position": Vector3(-(dimensionY/2)+(wall_thickness/2), 0, -(dimensionZ/2)+(wall_thickness/2)),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeBR": {
					"object": edge.instantiate(),
					"position": Vector3((dimensionY/2)-(wall_thickness/2), 0, -(dimensionZ/2)+(wall_thickness/2)),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeBD": {
					"object": edge.instantiate(),
					"position": Vector3(0, -(dimensionY/2)+(wall_thickness/2), -(dimensionZ/2)+(wall_thickness/2)),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
				
		"edgeLU": {
					"object": edge.instantiate(),
					"position": Vector3(-(dimensionX/2)+(wall_thickness/2), (dimensionY/2)-(wall_thickness/2), 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
		"edgeLD": {
					"object": edge.instantiate(),
					"position": Vector3(-(dimensionX/2)+(wall_thickness/2), -(dimensionY/2)+(wall_thickness/2), 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
		"edgeRU": {
					"object": edge.instantiate(),
					"position": Vector3((dimensionX/2)-(wall_thickness/2), (dimensionY/2)-(wall_thickness/2), 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
		"edgeRD": {
					"object": edge.instantiate(),
					"position": Vector3((dimensionX/2)-(wall_thickness/2), -(dimensionY/2)+(wall_thickness/2), 0),
					"rotation": Vector3(90*PI/180, 0, 0),
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
		
	for edge in edgeDictionary:
		add_child(edgeDictionary[edge]["object"])
		edgeDictionary[edge]["object"].position = edgeDictionary[edge]["position"]
		edgeDictionary[edge]["object"].rotation = edgeDictionary[edge]["rotation"]
	
	base.BaseGrid[Vector3(position.x, position.y, position.z)] = self
	
	print(position)
	print(wallDictionary["wallL"]["object"].global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
