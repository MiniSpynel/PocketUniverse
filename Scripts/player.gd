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
@onready var detect_wall_ray_cast = $Visuals/DetectWallRayCast
@onready var gizmo1 = $CSGSphere3D
@onready var gizmo2 = $CSGSphere3D2


var SPEED = 2
const JUMP_VELOCITY = 4.5
var walkingSpeed = 2
var runningSpeed = 5
var running: bool = false
var facing_wall = null

var camera_start_position = 0.0
var camera_aim_position = 0.6

var gravity = Vector3(0, -9.81, 0)
var gravity_intensity = 9.81
var target_gravity = Vector3(0, -9.81, 0)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("Interact"):
		if gravity == Vector3(9.81, 0, 0):
			target_gravity = Vector3(0, -9.81, 0)
		else:
			target_gravity = Vector3(9.81, 0, 0)

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

func _process(delta):
	gizmo1.global_position = global_position + transform.basis.z*1.5
	gizmo2.global_position = global_position + global_basis.z
	
	if detect_wall_ray_cast.is_colliding():
		facing_wall = detect_wall_ray_cast.get_collider()

func _physics_process(delta):
	
	handle_aiming(delta)
	handle_movement(delta)
	if gravity != target_gravity:
		shift_gravity(delta)

func shift_gravity(delta):
	gravity = lerp(gravity, target_gravity, delta*2)
	up_direction = -gravity.normalized()
	#var rotation_axis = gravity.cross(target_gravity).normalized()
	#rotate(rotation_axis.normalized(), delta/4)
	
	# Get the current up direction, which is the object's y-axis
	var current_up: Vector3 = global_transform.basis.y

	# Calculate the rotation axis which is the cross product of the current up and target up
	var rotation_axis: Vector3 = current_up.cross(up_direction).normalized()
	
	# Calculate the angle between the current up and target up
	var angle: float = acos(current_up.dot(up_direction))
	
	rotate(rotation_axis, angle)
	
	
	if gravity.angle_to(target_gravity)<0.05 and (target_gravity-gravity).length()<0.1:
		gravity = target_gravity

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
	var global_direction = transform.basis.get_rotation_quaternion().normalized() * direction
	print("wall: %s, direction: %s" % [facing_wall, direction])
	if direction != Vector3.ZERO:
		animationPlayer.play("running" if running else "walking")
	else:
		animationPlayer.play("idle")

	if facing_wall and Input.is_action_pressed("MoveForward"):
		
		target_gravity = -detect_wall_ray_cast.get_collision_normal()*gravity_intensity

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
