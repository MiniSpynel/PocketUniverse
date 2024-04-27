class_name Interactable
extends CSGBox3D

@export var prompt_action = "Interact"

func interact():
	position.x = lerp(position.x, position.x+1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
