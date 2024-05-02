extends RayCast3D

@export var structure: PackedScene
@export var holoShader: ShaderMaterial

@onready var structurePreview = structure.instantiate()

var aiming = false
var previewTargetPosition = Vector3.ZERO

func get_all_nodes_of_type(object: Node3D, type: String, result: Array = []):
	for child in object.get_children():
		if child.get_class() == type:
			result.append(child)
		get_all_nodes_of_type(child, type, result)
	
	return result

func _ready():
	# Add structurePreview to the scene
	get_tree().root.add_child.call_deferred(structurePreview)
	structurePreview.hide()
	
	for c in get_all_nodes_of_type(structurePreview, "CollisionShape3D"):
		c.disabled = true
	for m in get_all_nodes_of_type(structurePreview, "MeshInstance3D"):
		m.set_surface_override_material(0, holoShader)
	
	
func _input(event):
	if event.is_action_pressed("Aim"):
		aiming = true
	if event.is_action_released("Aim"):
		aiming = false
		structurePreview.hide()

	if is_colliding():
		var objectDetected = get_collider()

		# Interact with object
		if objectDetected is Interactable and event.is_action_pressed(objectDetected.prompt_action):
			objectDetected.interact()
			
		# Build new structure
		if objectDetected is BuildableArea:
			var wall = objectDetected
			var module = wall.get_parent()
			
			if aiming:
				previewTargetPosition = objectDetected.global_position
				structurePreview.show()
			
				if event.is_action_pressed("LeftClick"):
					var newStructure = structure.instantiate()
					get_tree().root.add_child(newStructure)
					newStructure.global_position = objectDetected.global_position
		else:
			structurePreview.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if structurePreview and structurePreview.is_inside_tree():
		structurePreview.global_position = lerp(structurePreview.global_position, previewTargetPosition, 10 * delta)
	else:
		print("structurePreview is not in the scene tree")
