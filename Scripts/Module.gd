extends Node3D


@export_category("Walls")
@export var wallFront: PackedScene
@export var wallBack: PackedScene
@export var wallLeft: PackedScene
@export var wallRight: PackedScene
@export var wallUp: PackedScene
@export var wallDown: PackedScene

@export_category("Dimensions")
@export var dimensionX: float = 10
@export var dimensionY: float = 10
@export var dimensionZ: float = 10

@export_category("Neighouring modules")
@export var NeighbourFront: Node3D
@export var NeighbourBack: Node3D
@export var NeighbourLeft: Node3D
@export var NeighbourRight: Node3D
@export var NeighbourUp: Node3D
@export var NeighbourDown: Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var wallF = wallFront.instantiate()
	var wallB = wallBack.instantiate()
	var wallL = wallLeft.instantiate()
	var wallR = wallRight.instantiate()
	var wallU = wallUp.instantiate()
	var wallD = wallDown.instantiate()
	
	wallF.set_script( load("res://Scripts/Wall.gd") )
	wallB.set_script( load("res://Scripts/Wall.gd") )
	wallL.set_script( load("res://Scripts/Wall.gd") )
	wallR.set_script( load("res://Scripts/Wall.gd") )
	wallU.set_script( load("res://Scripts/Wall.gd") )
	wallD.set_script( load("res://Scripts/Wall.gd") )
	
	wallF.newRoomDirection = Vector3(0, 0, dimensionZ/2)
	wallB.newRoomDirection = Vector3(0, 0, -dimensionZ/2)
	wallL.newRoomDirection = Vector3(-dimensionX/2, 0, 0)
	wallR.newRoomDirection = Vector3(dimensionX/2, 0, 0)
	wallU.newRoomDirection = Vector3(0, dimensionY/2, 0)
	wallD.newRoomDirection = Vector3(0, -dimensionY/2, 0)
	
	wallF.Room = self
	wallB.Room = self
	wallL.Room = self
	wallR.Room = self
	wallU.Room = self
	wallD.Room = self
	
	add_child(wallF)
	add_child(wallB)
	add_child(wallL)
	add_child(wallR)
	add_child(wallU)
	add_child(wallD)
	
	wallF.position = Vector3(position.x, position.y, position.z+(dimensionX/2))
	wallB.position = Vector3(position.x, position.y, position.z-(dimensionX/2))
	wallL.position = Vector3(position.x-(dimensionZ/2), position.y, position.z)
	wallR.position = Vector3(position.x+(dimensionZ/2), position.y, position.z)
	wallU.position = Vector3(position.x, position.y+(dimensionY/2), position.z)
	wallD.position = Vector3(position.x, position.y-(dimensionY/2), position.z)
	
	wallL.rotation = Vector3(0, 90*PI/180, 0)
	wallR.rotation = Vector3(0, 90*PI/180, 0)
	wallU.rotation = Vector3(90*PI/180, 0, 0)
	wallD.rotation = Vector3(90*PI/180, 0, 0)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
