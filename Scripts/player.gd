extends CharacterBody3D

signal toggle_inventory
signal toggle_build_menu

@export var sensitivity_horizontal = 0.15
@export var sensitivity_vertical = 0.15
@export var inventory_data: InventoryData

@onready var visuals = $Visuals
@onready var camera = $CameraMountX/CameraMountY/SpringArm3D/Camera3D
@onready var spring_arm_3d = $CameraMountX/CameraMountY/SpringArm3D
@onready var cameraMountX = $CameraMountX
@onready var cameraMountY = $CameraMountX/CameraMountY
@onready var animationPlayer = $Visuals/mixamo_base/AnimationPlayer

@onready var world = $".."
@onready var cursor = $"../UI/ColorRect"
@onready var build_menu_interface = $"../UI/BuildMenuInterface"
@onready var inventory_interface = $"../UI/InventoryInterface"


var SPEED = 2
const JUMP_VELOCITY = 4.5
var walkingSpeed = 2
var runningSpeed = 5
var running = false

var camera_start_position = 0.0
var camera_aim_position = 0.6


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion and not build_menu_interface.visible and not inventory_interface.visible:
		cameraMountX.rotate_y(deg_to_rad(-event.relative.x * sensitivity_horizontal))
		cameraMountY.rotation_degrees.x = clamp(cameraMountY.rotation_degrees.x - event.relative.y * sensitivity_vertical, -70, 80)
		
	if event.is_action_pressed("BuildMenu"):
		toggle_build_menu.emit()
			
	if event.is_action_pressed("Run"):
		SPEED = runningSpeed
		running = true
	if event.is_action_released("Run"):
		SPEED = walkingSpeed
		running = false
		
	if event.is_action_pressed("Inventory"):
		toggle_inventory.emit()

func _physics_process(delta):
		
	if Input.is_action_pressed("Aim"):
		spring_arm_3d.position.x = lerp(spring_arm_3d.position.x, camera_aim_position, 5*delta)
		cursor.show()
	else:
		spring_arm_3d.position.x = lerp(spring_arm_3d.position.x, camera_start_position, 5*delta)
		cursor.hide()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	var direction = (cameraMountX.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if running:
			if animationPlayer.current_animation != "running":
				animationPlayer.play("running")
		else:
			if animationPlayer.current_animation != "walking":
				animationPlayer.play("walking")
		
		
		visuals.look_at(lerp(position - visuals.basis.z, position + direction, 10*delta))
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animationPlayer.current_animation != "idle":
			animationPlayer.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

