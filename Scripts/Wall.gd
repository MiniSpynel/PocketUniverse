extends BuildableArea

var room = load("res://Scenes/Module.tscn")

@export var newRoomDirection : Vector3
@export var Room : Node3D
@onready var base: Node3D

func create_new_room():
	var new_room = room.instantiate()
	new_room.position = Room.position + newRoomDirection
	get_tree().root.get_node("World/GlobalBase").add_child(new_room)
	
	base.clear_walls()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
