extends KinematicBody2D

signal player_died

const BULLET: PackedScene = preload("res://Player/AR_Bullet.tscn")

onready var shoot_point = get_node("ShootPivoit/ShootPoint")

# For Initializing horizontal movement speed
export(float) var horizontal_speed = 100.0

# For Initializing Gravity.
export(float) var jump_height = 50.0
export(float) var jump_time_to_peak = 0.5
export(float) var jump_time_to_land = 0.4

export(float) var acceleration = 0.5
export(float) var friction = 0.2

# Calculate Jump Velocity
onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak

# Calculate Gravity
onready var jump_gravity: float = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
onready var fall_gravity: float = (2.0 * jump_height) / (jump_time_to_land * jump_time_to_land)

# Setting node references
onready var collisionShape = get_node("CollisionShape2D")
onready var movementSprite = get_node("MovementSprite")
onready var animTree = get_node("AnimationTree")
onready var animMode = get_node("AnimationTree").get("parameters/playback")
onready var health = get_node("Health")
onready var gunSoundPlayer = get_node("GunSoundPlayer")
onready var hurtbox = get_node("Hurtbox/CollisionShape2D")
onready var state_machine = get_node("MovementStates")

func get_health() -> Node:
	return health

func stop_controls() -> void:
	hurtbox.set_deferred("disabled", true)
	state_machine.set_physics_process(false)
	
	movementSprite.set_process(false)
	movementSprite.play("idle")
	movementSprite.stop()
	
	get_node("ShootingSprite").set_process(false)
	get_node("ShootPivoit").set_process(false)

func die() -> void:
	emit_signal("player_died")
	animMode.travel("die")
	

	
	movementSprite.visible = false
	stop_controls()
	

func _on_Health_fatal_damage() -> void:
	die()

func _ready() -> void:
	get_node("MovementStates").init()
	get_node("ShootingManager").init()

func shoot() -> void:
	# Instance Bullet
	var bullet = BULLET.instance()
	
	# Update bullet rotation & Direction.
	bullet.position = shoot_point.global_position
	bullet.rotation = shoot_point.global_rotation
	get_tree().get_root().add_child(bullet)
	gunSoundPlayer.play()
