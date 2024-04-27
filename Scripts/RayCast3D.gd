extends RayCast3D

@export var structure: PackedScene
@export var holoShader = VisualShader

@onready var structurePreview = structure.instantiate().get_node("Main").duplicate()

var aiming = false
var previewTargetPosition = Vector3.ZERO

func _ready():
	structurePreview.get_node("CollisionShape3D").disabled = true
	get_tree().root.add_child.call_deferred(structurePreview)
	structurePreview.hide()
	
func _input(event):
	if is_colliding():
		var objectDetected = get_collider()
		previewTargetPosition = get_collision_point()
		
		# New code here
		if event.is_action_pressed("Aim"):
			aiming = true
		if aiming:
			structurePreview.show()
		if event.is_action_released("Aim"):
			aiming = false
			structurePreview.hide()
		
		
		# Interact with object
		if objectDetected is Interactable and event.is_action_pressed(objectDetected.prompt_action):
			objectDetected.interact()
			
		# Build new structure
		if objectDetected is Buildable:
			previewTargetPosition = objectDetected.global_position
			
			if event.is_action_pressed("LeftClick"):
				var newStructure = structure.instantiate()
				get_tree().root.add_child(newStructure)
				newStructure.global_position = objectDetected.global_position
	elif structurePreview.visible:
		structurePreview.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	structurePreview.global_position = lerp(structurePreview.global_position, previewTargetPosition, 10*delta)
