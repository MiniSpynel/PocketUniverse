extends CharacterBody3D

signal toggle_menu
signal toggle_inventory
signal toggle_build_menu

@export var sensitivity_horizontal = 0.15
@export var sensitivity_vertical = 0.15
@export var inventory_data: InventoryData
@export var holoShader: ShaderMaterial
@export var blend_speed = 15

@onready var visuals = $Visuals
@onready var camera = $CameraMountX/CameraMountY/SpringArm3D/Camera3D
@onready var spring_arm_3d = $CameraMountX/CameraMountY/SpringArm3D
@onready var cameraMountX = $CameraMountX
@onready var cameraMountY = $CameraMountX/CameraMountY
@onready var animationPlayer = $Visuals/mixamo_base/AnimationPlayer

@onready var world = $".."
@onready var UI = $"../UI"
@onready var cursor = UI.cursor
@onready var build_menu_interface = UI.buildMenu
@onready var inventory_interface = UI.inventoryMenu

@onready var aiming_ray_cast = $CameraMountX/CameraMountY/SpringArm3D/Camera3D/AimingRayCast
@onready var detect_wall_ray_cast = $Visuals/DetectWallRayCast
@onready var animation_tree = $Visuals/mixamo_base/AnimationTree


enum {IDLE, WALK, RUN}
var current_animation = IDLE
var building = false
var new_structure = null
var preview_structure = null

var run_val = 0.0
var walk_val = 0.0

var SPEED = 2
const JUMP_VELOCITY = 4.5
var walkingSpeed = 2
var runningSpeed = 5
var running: bool = false
var facing_wall = null
var bottom_wall = null
var aiming = false

var camera_start_position = 0.0
var camera_aim_position = 0.6

var gravity = Vector3(0, -9.81, 0)
var gravity_intensity = 9.81
var target_gravity = Vector3(0, -9.81, 0)

func _ready():
	build_menu_interface.structure_select.connect(update_new_structure)

func update_new_structure(struct):
	# Security
	if !struct:
		return
	
	new_structure = struct
	preview_structure = struct.object.instantiate()
	if struct.resource_path == "res://Resources/Techs/BaseModule.tres":
		$"../GlobalBase".add_child(preview_structure)
	else:
		world.add_child(preview_structure)
	
	for c in get_all_nodes_of_type(preview_structure, "CollisionShape3D"):
		c.disabled = true
	for m in get_all_nodes_of_type(preview_structure, "MeshInstance3D"):
		m.material_override = holoShader
	
	building = true
	
func place_structure():
	if new_structure and preview_structure:
		var duplicate = new_structure.object.instantiate()
		duplicate.position = preview_structure.position
		duplicate.rotation = preview_structure.rotation
		world.add_child(duplicate)
		preview_structure.queue_free()
		preview_structure = null
		new_structure = null
	building = false

func get_all_nodes_of_type(object: Node3D, type: String, result: Array = []):
	for child in object.get_children():
		if child.get_class() == type:
			result.append(child)
		get_all_nodes_of_type(child, type, result)
	return result

func handle_animation(delta):
	match current_animation:
		IDLE:
			walk_val = lerp(walk_val, 0.0, delta*blend_speed)
			run_val = lerp(run_val, 0.0, delta*blend_speed)
		WALK:
			walk_val = lerp(walk_val, 1.0, delta*blend_speed)
			run_val = lerp(run_val, 0.0, delta*blend_speed)
		RUN:
			walk_val = lerp(walk_val, 0.0, delta*blend_speed)
			run_val = lerp(run_val, 1.0, delta*blend_speed)
	update_animation_tree()

func update_animation_tree():
	animation_tree["parameters/Run/blend_amount"] = run_val
	animation_tree["parameters/Walk/blend_amount"] = walk_val

func _input(event):
	if event is InputEventMouseMotion and world.cameraMove:
		cameraMountX.rotate_y(deg_to_rad(-event.relative.x * sensitivity_horizontal))
		cameraMountY.rotation_degrees.x = clamp(cameraMountY.rotation_degrees.x - event.relative.y * sensitivity_vertical, -70, 80)
	
	if event.is_action_pressed("Run"):
		SPEED = runningSpeed
		running = true
	if event.is_action_released("Run"):
		SPEED = walkingSpeed
		running = false
	
	if event.is_action_pressed("BuildMenu"):
		toggle_build_menu.emit()
	if event.is_action_pressed("Inventory"):
		toggle_inventory.emit()
	if event.is_action_pressed("Escape"):
		toggle_menu.emit()
		
	if event.is_action_pressed("LeftClick"):
		if building:
			place_structure()
		else:
			if aiming and aiming_ray_cast.is_colliding():
				var objectDetected = aiming_ray_cast.get_collider()
				
				if objectDetected.get_parent() is BuildableArea:
					var wall = objectDetected.get_parent()
					
					wall.create_new_room()

func _process(delta):
	
	facing_wall = detect_wall_ray_cast.get_collider()
	handle_animation(delta)

func _physics_process(delta):
	
	handle_aiming(delta)
	handle_movement(delta)
	handle_placement(delta)
	if gravity != target_gravity:
		shift_gravity(delta)

func shift_gravity(delta):
	gravity = lerp(gravity, target_gravity, delta*5)
	up_direction = -gravity.normalized()

	var current_up: Vector3 = global_transform.basis.y

	var rotation_axis: Vector3 = current_up.cross(up_direction).normalized()
	
	var angle: float = acos(current_up.dot(up_direction))
	
	rotate(rotation_axis, angle)
	
	
	if gravity.angle_to(target_gravity)<0.05 and (target_gravity-gravity).length()<0.1:
		gravity = target_gravity
		up_direction = -gravity.normalized()
		current_up = global_transform.basis.y
		rotation_axis = current_up.cross(up_direction).normalized()
		angle = acos(current_up.dot(up_direction))
		rotate(rotation_axis, angle)

func handle_aiming(delta):
	if Input.is_action_pressed("Aim"):
		aiming = true
		spring_arm_3d.position.x = lerp(spring_arm_3d.position.x, camera_aim_position, 5 * delta)
		cursor.show()
	else:
		aiming = false
		spring_arm_3d.position.x = lerp(spring_arm_3d.position.x, camera_start_position, 5 * delta)
		cursor.hide()

func handle_movement(delta):
	
	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	var direction = (cameraMountX.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var global_direction = transform.basis.get_rotation_quaternion().normalized() * direction
	
	if direction != Vector3.ZERO:
		current_animation = RUN if running else WALK
	else:
		current_animation = IDLE
	
	
	if facing_wall and Input.is_action_pressed("MoveForward"):
		target_gravity = -detect_wall_ray_cast.get_collision_normal()*gravity_intensity
	#if not facing_wall and bottom_wall and not is_on_floor():
		#target_gravity = -detect_bottom_wall_ray_cast.get_collision_normal()*gravity_intensity

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

func handle_placement(delta):
	if !preview_structure:
		return
	preview_structure.position = lerp(preview_structure.position, aiming_ray_cast.get_collision_point(), delta*15)
	preview_structure.rotation = rotation
	



