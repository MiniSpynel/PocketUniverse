extends ModuleClass

var wallDictionary : Dictionary = {}
var edgeDictionary : Dictionary = {}
var cornerDictionary : Dictionary = {}

@export_category("Components")
@export var wall: PackedScene
@export var edge: PackedScene
@export var corner: PackedScene
@export var light: PackedScene

@onready var base: Node3D = $".."

func update_wall(name: String, object: PackedScene = null):
	if wallDictionary[name]["object"] != null:
		wallDictionary[name]["object"].queue_free()
	if object != null:
		wallDictionary[name]["object"] = object.instantiate()
		add_child(wallDictionary[name]["object"])
		wallDictionary[name].position = wallDictionary[name]["position"]
		wallDictionary[name].rotation = wallDictionary[name]["rotation"]
	
func update_edge(name: String, object: PackedScene = null):
	if edgeDictionary[name]["object"] != null:
		edgeDictionary[name]["object"].queue_free()
	if object != null :
		edgeDictionary[name]["object"] = object.instantiate()
		add_child(edgeDictionary[name]["object"])
		edgeDictionary[name].position = edgeDictionary[name]["position"]
		edgeDictionary[name].rotation = edgeDictionary[name]["rotation"]
		
func update_corner(name: String, object: PackedScene = null):
	if cornerDictionary[name]["object"] != null:
		cornerDictionary[name]["object"].queue_free()
	if object != null :
		cornerDictionary[name]["object"] = object.instantiate()
		add_child(cornerDictionary[name]["object"])
		cornerDictionary[name].position = cornerDictionary[name]["position"]
		cornerDictionary[name].rotation = cornerDictionary[name]["rotation"]


# Called when the node enters the scene tree for the first time.
func _ready():
	var offset = (dimension/2)-(wall_thickness/2)
	wallDictionary = {
		"wallF": {
					"object": wall.instantiate(),
					"position": Vector3(0, 0, offset),
					"rotation": Vector3(0, 0, 0),
					"direction": Vector3(0, 0, dimension)
				},
		"wallB": {
					"object": wall.instantiate(),
					"position": Vector3(0, 0, -offset),
					"rotation": Vector3(0, 0, 0),
					"direction": Vector3(0, 0, -dimension)
				},
		"wallL": {
					"object": wall.instantiate(),
					"position": Vector3(-offset, 0, 0),
					"rotation": Vector3(0, 90*PI/180, 0),
					"direction": Vector3(-dimension, 0, 0)
				},
		"wallR": {
					"object": wall.instantiate(),
					"position": Vector3(offset, 0, 0),
					"rotation": Vector3(0, 90*PI/180, 0),
					"direction": Vector3(dimension, 0, 0)
				},
		"wallU": {
					"object": wall.instantiate(),
					"position": Vector3(0, offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
					"direction": Vector3(0, dimension, 0)
				},
		"wallD": {
					"object": wall.instantiate(),
					"position": Vector3(0, -offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
					"direction": Vector3(0, -dimension, 0)
				},
	}
	edgeDictionary = {
		"edgeFU": {
					"object": edge.instantiate(),
					"position": Vector3(0, offset, offset),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
		"edgeFL": {
					"object": edge.instantiate(),
					"position": Vector3(-offset, 0, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeFR": {
					"object": edge.instantiate(),
					"position": Vector3(offset, 0, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeFD": {
					"object": edge.instantiate(),
					"position": Vector3(0, -offset, offset),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
				
		"edgeBU": {
					"object": edge.instantiate(),
					"position": Vector3(0, offset, -offset),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
		"edgeBL": {
					"object": edge.instantiate(),
					"position": Vector3(-offset, 0, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeBR": {
					"object": edge.instantiate(),
					"position": Vector3(offset, 0, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeBD": {
					"object": edge.instantiate(),
					"position": Vector3(0, -offset, -offset),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
				
		"edgeLU": {
					"object": edge.instantiate(),
					"position": Vector3(-offset, offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
		"edgeLD": {
					"object": edge.instantiate(),
					"position": Vector3(-offset, -offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
		"edgeRU": {
					"object": edge.instantiate(),
					"position": Vector3(offset, offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
		"edgeRD": {
					"object": edge.instantiate(),
					"position": Vector3(offset, -offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
	}
	cornerDictionary = {
		"cornerFLU": {
					"object": corner.instantiate(),
					"position": Vector3(-offset, offset, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerFLD": {
					"object": corner.instantiate(),
					"position": Vector3(-offset, -offset, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerFRU": {
					"object": corner.instantiate(),
					"position": Vector3(offset, offset, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerFRD": {
					"object": corner.instantiate(),
					"position": Vector3(offset, -offset, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerBLU": {
					"object": corner.instantiate(),
					"position": Vector3(-offset, offset, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerBLD": {
					"object": corner.instantiate(),
					"position": Vector3(-offset, -offset, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerBRU": {
					"object": corner.instantiate(),
					"position": Vector3(offset, offset, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerBRD": {
					"object": corner.instantiate(),
					"position": Vector3(offset, -offset, -offset),
					"rotation": Vector3(0, 0, 0),
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
		
	for corner in cornerDictionary:
		add_child(cornerDictionary[corner]["object"])
		cornerDictionary[corner]["object"].position = cornerDictionary[corner]["position"]
		cornerDictionary[corner]["object"].rotation = cornerDictionary[corner]["rotation"]
	
	base.BaseGrid[Vector3(position.x, position.y, position.z)] = self
	
	add_child(light.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
