extends PanelContainer

signal structure_select(struct)

@export var tech: Tech
@onready var texture_rect = $VBoxContainer/MarginContainer/TextureRect
@onready var label = $VBoxContainer/MarginContainer2/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = tech.texture if tech.texture else load("res://Resources/Textures/Sprite-0001.png")
	label.text = tech.name if tech.name else "unnamed"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		structure_select.emit(tech)
