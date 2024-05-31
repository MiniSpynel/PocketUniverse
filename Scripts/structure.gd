class_name Structure
extends Node3D

enum structureType { MODULE, WALL, OBJECT }

@export var type: structureType
@export var mesh: MeshInstance3D
@export var hitbox: CollisionShape3D
@export var boundaries: Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



