extends BuildableArea

var room = load("res://Scenes/Module.tscn")

@export var newRoomDirection : Vector3
@export var Room : Node3D

func create_new_room():
	print("Script called")
	var new_room = room.instantiate()
	new_room.position = Room.position + newRoomDirection
	get_tree().root.add_child(new_room)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Script initialised")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
