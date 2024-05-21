extends MarginContainer

signal structure_select(struct)

@onready var grid_container = $GridContainer
var buildable_structure_icon = preload("res://Scenes/buildable_structure_icon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_tech(tech: Tech):
	print(tech.name)
	var new_struct = buildable_structure_icon.instantiate()
	new_struct.tech = tech
	grid_container.add_child(new_struct)
	new_struct.structure_select.connect(structure_selected)

func structure_selected(struct):
	structure_select.emit(struct)
