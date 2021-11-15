extends KinematicBody2D

# For Initializing horizontal movement speed
export(float) var horizontal_speed = 100.0

# For Initializing Gravity.
export(float) var jump_height = 50.0
export(float) var jump_time_to_peak = 0.5
export(float) var jump_time_to_land = 0.4

# Calculate Jump Velocity
onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak

# Calculate Gravity
onready var jump_gravity: float = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
onready var fall_gravity: float = (2.0 * jump_height) / (jump_time_to_land * jump_time_to_land)

# Setting node references
onready var health = get_node("Health")
onready var animPlayer = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")

var velocity := Vector2.ZERO

func get_health() -> Node:
	return health

func die() -> void:
	queue_free()

func _on_Health_fatal_damage() -> void:
	die()

func add_falling_gravity(_velocity: Vector2) -> Vector2:
	_velocity.y += fall_gravity * get_physics_process_delta_time()
	return _velocity

func add_horizontal_velocity(_velocity: Vector2, direction: float, scale: float = 1) -> Vector2:
	_velocity.x = horizontal_speed * scale * direction
	return _velocity
