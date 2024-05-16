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

var gravity = Vector3(0, -9.81, 0)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("Interact"):
		if gravity == Vector3(9.81, 0, 0):
			gravity = Vector3(0, -9.81, 0)
			rotate_z(deg_to_rad(-90))
		else:
			gravity = Vector3(9.81, 0, 0)
			rotate_z(deg_to_rad(90))
		up_direction = -gravity.normalized()

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
	handle_aiming(delta)
	handle_movement(delta)

func handle_aiming(delta):
	if Input.is_action_pressed("Aim"):
		spring_arm_3d.position.x = lerp(spring_arm_3d.position.x, camera_aim_position, 5 * delta)
		cursor.show()
	else:
		spring_arm_3d.position.x = lerp(spring_arm_3d.position.x, camera_start_position, 5 * delta)
		cursor.hide()

func handle_movement(delta):
	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	var direction = (cameraMountX.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var global_direction = Quaternion(transform.basis).normalized() * direction

	if direction != Vector3.ZERO:
		animationPlayer.play("running" if running else "walking")
	else:
		animationPlayer.play("idle")


	if global_direction != Vector3.ZERO:
		var current_look_at = global_position - visuals.global_transform.basis.z
		var target_look_at = global_position + global_direction
		visuals.look_at(lerp(current_look_at, target_look_at, 10 * delta), up_direction)

	var horizontal_velocity = velocity - gravity.normalized() * velocity.dot(gravity.normalized())
	var vertical_velocity = gravity.normalized() * velocity.dot(gravity.normalized())

	horizontal_velocity = global_direction * SPEED

	if not is_on_floor():
		vertical_velocity += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		vertical_velocity = JUMP_VELOCITY * -gravity.normalized()

	velocity = horizontal_velocity + vertical_velocity
	move_and_slide()
