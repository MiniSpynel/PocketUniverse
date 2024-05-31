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
var run_val = 0.0
var walk_val = 0.0
var SPEED = 2
const JUMP_VELOCITY = 4.5
var walkingSpeed = 2
var runningSpeed = 5
var running: bool = false


var building = false
var can_be_placed = false
var aiming_at_wall = false
var new_structure = null
var preview_structure = null
var preview_structure_target_rotation = Vector3.ZERO

var facing_wall = null
var aiming = false
var object_aimed = null

var camera_start_position = 0.0
var camera_aim_position = 0.8

var gravity = Vector3(0, -9.81, 0)
var gravity_intensity = 9.81
var target_gravity = Vector3(0, -9.81, 0)

func _ready():
	build_menu_interface.structure_select.connect(update_new_structure)

func update_new_structure(struct):
	if !struct:
		return
	
	toggle_build_menu.emit()
	aiming = true
	
	new_structure = struct
	preview_structure = struct.object.instantiate()
	preview_structure.position = snapped(aiming_ray_cast.get_collision_point(), Vector3(0.5,0.5,0.5))
	
	match preview_structure.type:
		Structure.structureType.MODULE:
			print("module")
		Structure.structureType.WALL:
			print("wall")
		Structure.structureType.OBJECT:
			print("object")
			world.add_child(preview_structure)
			preview_structure.hitbox.disabled = true
			preview_structure.mesh.material_override = holoShader
	
	building = true
	
func place_structure():
	if new_structure and preview_structure:
		if not world.menu_open:
			var duplicate_structure = new_structure.object.instantiate()
			duplicate_structure.position = preview_structure.position
			duplicate_structure.rotation = preview_structure.rotation
			world.add_child(duplicate_structure)
		preview_structure.queue_free()
		preview_structure = null
		new_structure = null

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
	
	if event.is_action_pressed("Aim"):
		aiming = true
	if event.is_action_released("Aim"):
		aiming = false
	
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
			match preview_structure.type:
				Structure.structureType.MODULE:
					if object_aimed is Wall:
						object_aimed.create_new_room()
				Structure.structureType.OBJECT:
					if can_be_placed:
						place_structure()
			building = false
			aiming = false
			
	if event.is_action("ScrollUp"):
		preview_structure_target_rotation.y += 5
	if event.is_action("ScrollDown"):
		preview_structure_target_rotation.y -= 5

func _process(delta):
	object_aimed = aiming_ray_cast.get_collider()
	facing_wall = detect_wall_ray_cast.get_collider()
	handle_animation(delta)

func _physics_process(delta):
	
	handle_aiming(delta)
	handle_movement(delta)
	handle_placement(delta)
	if gravity != target_gravity:
		shift_gravity(delta)

func align_basis_up(basis: Basis, up_vector: Vector3) -> Basis:
	var current_up: Vector3 = basis.y.normalized()
	var rotation_axis: Vector3 = current_up.cross(up_vector).normalized()
	var angle: float = acos(clamp(current_up.dot(up_vector), -1.0, 1.0))
	
	if current_up.distance_to(up_vector) > 0.01:
		var align_quat = Quaternion(rotation_axis, angle)
		return Basis(align_quat) * basis
	else:
		return basis

func align_up(object: Node3D, up_vector: Vector3):
	var current_up: Vector3 = object.global_transform.basis.y.normalized()
	var rotation_axis: Vector3 = current_up.cross(up_vector).normalized()
	var angle: float = acos(clamp(current_up.dot(up_vector), -1.0, 1.0))
	
	if current_up.distance_to(up_vector) > 0.01:
		var align_quat = Quaternion(rotation_axis, angle)
		object.transform.basis = Basis(align_quat) * object.transform.basis

func shift_gravity(delta):
	gravity = lerp(gravity, target_gravity, delta*5)
	up_direction = -gravity.normalized()

	var current_up: Vector3 = global_transform.basis.y

	var rotation_axis: Vector3 = current_up.cross(up_direction).normalized()
	
	var angle: float = acos(current_up.dot(up_direction))
	
	rotate(rotation_axis, angle)
	
	if gravity.angle_to(target_gravity)<0.1 and (target_gravity-gravity).length()<0.2:
		gravity = target_gravity
		up_direction = -gravity.normalized()
		current_up = global_transform.basis.y
		rotation_axis = current_up.cross(up_direction).normalized()
		angle = acos(current_up.dot(up_direction))
		rotate(rotation_axis, angle)

func handle_aiming(delta):
	if aiming:
		spring_arm_3d.position.x = lerp(spring_arm_3d.position.x, camera_aim_position, 5 * delta)
		cursor.show()
	else:
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
	
	
	if facing_wall and Input.is_action_pressed("MoveForward") and detect_wall_ray_cast.get_collider() is Wall:
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

func handle_placement(delta):
	if !preview_structure:
		return
	
	match preview_structure.type:
		Structure.structureType.MODULE:
			pass
		Structure.structureType.WALL:
			pass
		Structure.structureType.OBJECT:
			# Align the up direction of the preview structure to the collision normal
			align_up(preview_structure, aiming_ray_cast.get_collision_normal())
			
			# Smoothly interpolate the position to snap it to the grid
			preview_structure.position = lerp(preview_structure.position, snapped(aiming_ray_cast.get_collision_point(), Vector3(0.5, 0.5, 0.5)), delta * 15)
			
			# Create the current and target rotation quaternions
			var current_rotation_quat = preview_structure.transform.basis.get_rotation_quaternion()
			var target_rotation_basis = Basis(aiming_ray_cast.get_collision_normal(), deg_to_rad(preview_structure_target_rotation.y))
			target_rotation_basis = align_basis_up(target_rotation_basis, aiming_ray_cast.get_collision_normal())
			var target_rotation_quat = Quaternion(target_rotation_basis)
			# Interpolate between the current and target rotation quaternions
			var new_rotation_quat = current_rotation_quat.slerp(target_rotation_quat, delta * 15)

			# Apply the new rotation to the preview structure
			preview_structure.transform.basis = Basis(new_rotation_quat)
			
			# Handle the material color based on overlapping bodies
			var area = preview_structure.boundaries
			if area and area.get_overlapping_bodies().size() > 0:
				preview_structure.mesh.material_override.set_shader_parameter("Main_color", Color(1, 0, 0))
				can_be_placed = false
			else:
				preview_structure.mesh.material_override.set_shader_parameter("Main_color", Color(0, 1, 0))
				can_be_placed = true
