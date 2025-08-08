extends Node3D

class_name Rotator

@export var node: Node3D

signal tap_detected
var tap_start_time: float = 0.0

# Settings
@export var rotation_sensitivity: float = 0.01
@export var damping: float = 0.1
@export var return_speed: float = 10
@export var short_tap_threshold: float = 0.2

# Initial rotation state
var initial_rotation: Basis
var initial_date: Basis
var is_rotating: bool = false

# Rotation velocity
var rotation_velocity: Vector3 = Vector3.ZERO

func _ready():
	initial_rotation = node.transform.basis
	node.set_process(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and is_mouse_over_object():
				tap_start_time = Time.get_ticks_msec() / 1000.0
				is_rotating = true
			else:
				is_rotating = false
				var tap_duration = (Time.get_ticks_msec() / 1000.0) - tap_start_time
				if tap_duration < short_tap_threshold:
					tap_detected.emit()

	elif event is InputEventMouseMotion and is_rotating:
		# Calculate rotation velocity based on mouse movement
		rotation_velocity.x = event.relative.y * rotation_sensitivity
		rotation_velocity.y = -event.relative.x * rotation_sensitivity

func _process(delta):
	if is_rotating:
		# Apply rotation velocity to the object
		if rotation_velocity.length() > 0.001:
			node.rotate_object_local(Vector3(1, 0, 0), rotation_velocity.x * delta)
			node.rotate_object_local(Vector3(0, -1, 0), rotation_velocity.y * delta)

			# Apply damping to the rotation velocity
			rotation_velocity = rotation_velocity.lerp(Vector3.ZERO, damping * delta)
	else:
		# Smoothly interpolate back to the initial rotation
		node.transform.basis = node.transform.basis.orthonormalized().slerp(initial_rotation, return_speed * delta)

func is_mouse_over_object() -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var from = get_viewport().get_camera_3d().project_ray_origin(mouse_position)
	var to = get_viewport().get_camera_3d().project_position(mouse_position, 1000)
	
	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	params.collision_mask = 1
	#params.exclude = [node]
	var result = space_state.intersect_ray(params)
	#print(result)
	if result.is_empty():
		return false
	else:
		return result.collider == node
