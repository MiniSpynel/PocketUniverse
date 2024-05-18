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
	#get_tree().root.add_child.call_deferred(structurePreview)
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


	if event.is_action_pressed("LeftClick"):
		if aiming and is_colliding():
			var objectDetected = get_collider()
			
			if objectDetected.get_parent() is BuildableArea:
				var wall = objectDetected.get_parent()

				wall.create_new_room()

		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if structurePreview and structurePreview.is_inside_tree():
	#	structurePreview.global_position = lerp(structurePreview.global_position, previewTargetPosition, 10 * delta)
	#else:
	#	print("structurePreview is not in the scene tree")
	pass
