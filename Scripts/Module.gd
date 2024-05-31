extends Structure

var wallDictionary : Dictionary = {}
var edgeDictionary : Dictionary = {}
var cornerDictionary : Dictionary = {}

var wall_thickness = 0.5
var dimension: float = 5

@export_category("Components")
@export var wall_scene: PackedScene
@export var edge_scene: PackedScene
@export var corner_scene: PackedScene
@export var light_scene: PackedScene

@onready var base: Node = $".."

func update_wall(wallName: String, object: PackedScene = null):
	if wallDictionary[wallName]["object"] != null:
		wallDictionary[wallName]["object"].queue_free()
	if object != null:
		wallDictionary[wallName]["object"] = object.instantiate()
		add_child(wallDictionary[wallName]["object"])
		wallDictionary[wallName].position = wallDictionary[wallName]["position"]
		wallDictionary[wallName].rotation = wallDictionary[wallName]["rotation"]
	
func update_edge(edgeName: String, object: PackedScene = null):
	if edgeDictionary[edgeName]["object"] != null:
		edgeDictionary[edgeName]["object"].queue_free()
	if object != null :
		edgeDictionary[edgeName]["object"] = object.instantiate()
		add_child(edgeDictionary[edgeName]["object"])
		edgeDictionary[edgeName].position = edgeDictionary[edgeName]["position"]
		edgeDictionary[edgeName].rotation = edgeDictionary[edgeName]["rotation"]
		
func update_corner(cornerName: String, object: PackedScene = null):
	if cornerDictionary[cornerName]["object"] != null:
		cornerDictionary[cornerName]["object"].queue_free()
	if object != null :
		cornerDictionary[cornerName]["object"] = object.instantiate()
		add_child(cornerDictionary[cornerName]["object"])
		cornerDictionary[cornerName].position = cornerDictionary[cornerName]["position"]
		cornerDictionary[cornerName].rotation = cornerDictionary[cornerName]["rotation"]


# Called when the node enters the scene tree for the first time.
func _ready():
	var offset = (dimension/2)-(wall_thickness/2)
	wallDictionary = {
		"wallF": {
					"object": wall_scene.instantiate(),
					"position": Vector3(0, 0, offset),
					"rotation": Vector3(0, 0, 0),
					"direction": Vector3(0, 0, dimension)
				},
		"wallB": {
					"object": wall_scene.instantiate(),
					"position": Vector3(0, 0, -offset),
					"rotation": Vector3(0, 0, 0),
					"direction": Vector3(0, 0, -dimension)
				},
		"wallL": {
					"object": wall_scene.instantiate(),
					"position": Vector3(-offset, 0, 0),
					"rotation": Vector3(0, 90*PI/180, 0),
					"direction": Vector3(-dimension, 0, 0)
				},
		"wallR": {
					"object": wall_scene.instantiate(),
					"position": Vector3(offset, 0, 0),
					"rotation": Vector3(0, 90*PI/180, 0),
					"direction": Vector3(dimension, 0, 0)
				},
		"wallU": {
					"object": wall_scene.instantiate(),
					"position": Vector3(0, offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
					"direction": Vector3(0, dimension, 0)
				},
		"wallD": {
					"object": wall_scene.instantiate(),
					"position": Vector3(0, -offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
					"direction": Vector3(0, -dimension, 0)
				},
	}
	edgeDictionary = {
		"edgeFU": {
					"object": edge_scene.instantiate(),
					"position": Vector3(0, offset, offset),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
		"edgeFL": {
					"object": edge_scene.instantiate(),
					"position": Vector3(-offset, 0, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeFR": {
					"object": edge_scene.instantiate(),
					"position": Vector3(offset, 0, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeFD": {
					"object": edge_scene.instantiate(),
					"position": Vector3(0, -offset, offset),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
				
		"edgeBU": {
					"object": edge_scene.instantiate(),
					"position": Vector3(0, offset, -offset),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
		"edgeBL": {
					"object": edge_scene.instantiate(),
					"position": Vector3(-offset, 0, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeBR": {
					"object": edge_scene.instantiate(),
					"position": Vector3(offset, 0, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"edgeBD": {
					"object": edge_scene.instantiate(),
					"position": Vector3(0, -offset, -offset),
					"rotation": Vector3(0, 0, 90*PI/180),
				},
				
		"edgeLU": {
					"object": edge_scene.instantiate(),
					"position": Vector3(-offset, offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
		"edgeLD": {
					"object": edge_scene.instantiate(),
					"position": Vector3(-offset, -offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
		"edgeRU": {
					"object": edge_scene.instantiate(),
					"position": Vector3(offset, offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
		"edgeRD": {
					"object": edge_scene.instantiate(),
					"position": Vector3(offset, -offset, 0),
					"rotation": Vector3(90*PI/180, 0, 0),
				},
	}
	cornerDictionary = {
		"cornerFLU": {
					"object": corner_scene.instantiate(),
					"position": Vector3(-offset, offset, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerFLD": {
					"object": corner_scene.instantiate(),
					"position": Vector3(-offset, -offset, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerFRU": {
					"object": corner_scene.instantiate(),
					"position": Vector3(offset, offset, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerFRD": {
					"object": corner_scene.instantiate(),
					"position": Vector3(offset, -offset, offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerBLU": {
					"object": corner_scene.instantiate(),
					"position": Vector3(-offset, offset, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerBLD": {
					"object": corner_scene.instantiate(),
					"position": Vector3(-offset, -offset, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerBRU": {
					"object": corner_scene.instantiate(),
					"position": Vector3(offset, offset, -offset),
					"rotation": Vector3(0, 0, 0),
				},
		"cornerBRD": {
					"object": corner_scene.instantiate(),
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
	
	add_child(light_scene.instantiate())

