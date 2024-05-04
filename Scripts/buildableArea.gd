extends BuildableArea


func build(structure: Node3D):
	get_tree().root.add_child(structure)
	structure.global_position = global_position


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
