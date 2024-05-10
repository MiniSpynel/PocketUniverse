extends Node3D

var wallDictionary : Dictionary = {}
var edgeDictionary : Dictionary = {}
var cornerDictionary : Dictionary = {}

var wall_thickness = 0.5
var dimension: float = 7

@export_category("Components")
@export var wall_scene: PackedScene
@export var edge_scene: PackedScene
@export var corner_scene: PackedScene
@export var light_scene: PackedScene

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
