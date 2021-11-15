extends "res://Entity/EntityBase.gd"

enum MobState {
	IDLE,
	ALERT,
	LOST_ALERT,
	WALK,
	SHOOT,
	DEAD
}

const MOB_BULLET: PackedScene = preload("res://AR_Mob/MobBullet.tscn")

export(MobState) var start_state = MobState.IDLE
export(bool) var flipped = false
onready var state = start_state

var death_direction = ""

onready var pivoit = get_node("pivoit")
onready var playerRaycast = get_node("pivoit/PlayerRaycast")
onready var floorChecker = get_node("pivoit/FloorChecker")
onready var backChecker = get_node("pivoit/backChecker")
onready var bubbleTimer = get_node("BubbleTimer")
onready var bubble = get_node("Bubble")
onready var label = get_node("Label")
onready var shoot_point = get_node("pivoit/shootPoint")

var already_shot = false

func _ready() -> void:
	if flipped:
		turn_around()
	start_current_state()

func _physics_process(_delta: float) -> void:
	velocity.x = 0
	
	match state:
		MobState.WALK:
			if self.is_on_wall() or not floorChecker.is_colliding() or backChecker.is_colliding():
				turn_around()
			velocity = add_horizontal_velocity(velocity, pivoit.scale.x, 0.5)
		MobState.LOST_ALERT:
			if self.is_on_wall() or not floorChecker.is_colliding() or backChecker.is_colliding():
				turn_around()
			velocity = add_horizontal_velocity(velocity, pivoit.scale.x, 0.3)
		MobState.SHOOT:
			if backChecker.is_colliding():
				turn_around()
			
	try_state_transition()
	
	velocity = add_falling_gravity(velocity)
	velocity = move_and_slide(velocity, Vector2.UP, true)

func try_state_transition() -> void:
	var new_state = get_state_transition()
	if state == new_state: return
	exit_current_state()
	state = new_state
	label.text = MobState.keys()[state]
	start_current_state()
	
func get_state_transition() -> int:
	match state:
		MobState.IDLE:
			if playerRaycast.is_colliding():
				return MobState.ALERT
			return MobState.IDLE
		MobState.ALERT:
			if not playerRaycast.is_colliding() and not bubbleTimer.is_stopped():
				return MobState.LOST_ALERT
			elif bubbleTimer.is_stopped():# or already_shot:
				return MobState.SHOOT
			return MobState.ALERT
		MobState.LOST_ALERT:
			if playerRaycast.is_colliding():
				return MobState.ALERT
			elif bubbleTimer.is_stopped():
				return start_state
			return MobState.LOST_ALERT
		MobState.SHOOT:
			if not playerRaycast.is_colliding() and not backChecker.is_colliding():
				return MobState.LOST_ALERT
			return MobState.SHOOT
		MobState.WALK:
			if playerRaycast.is_colliding():
				return MobState.ALERT
			return MobState.WALK
		MobState.DEAD:
			return MobState.DEAD
	return MobState.IDLE

func exit_current_state() -> void:
	match state:
		MobState.ALERT:
			bubble.visible = false
			bubble.stop()
		MobState.LOST_ALERT:
			bubble.visible = false
			floorChecker.enabled = false
			bubble.stop()
	pass

func start_current_state() -> void:
	match state:
		MobState.IDLE:
			animPlayer.play("idle")
		MobState.ALERT:
			bubble.visible = true
			bubble.play("alert")
			animPlayer.play("idle", -1, 2)
			bubbleTimer.start(0.7)
		MobState.LOST_ALERT:
			bubble.visible = true
			bubble.play("question")
			animPlayer.play("walk", -1, 0.3)
			floorChecker.enabled = true
			bubbleTimer.start(3)
		MobState.SHOOT:
			already_shot = true
			animPlayer.play("shoot")
		MobState.WALK:
			animPlayer.play("walk", -1, 0.5)
			floorChecker.enabled = true
	pass

func turn_around() -> void:
	sprite.flip_h = not sprite.flip_h
	pivoit.scale.x = -1 * pivoit.scale.x

func shoot() -> void:
	# Instance Bullet
	var bullet = MOB_BULLET.instance()
	
	# Update bullet rotation & Direction.
	bullet.position = shoot_point.global_position
	bullet.rotation = shoot_point.global_rotation
	get_tree().get_root().add_child(bullet)
	#gunSoundPlayer.play()

func die():
	state = MobState.DEAD
	set_physics_process(false)
	get_node("pivoit/Hitbox/CollisionShape2D").set_deferred("disabled", true)
	get_node("pivoit/Hitbox_back/CollisionShape2D").set_deferred("disabled", true)
	bubble.visible = false
	bubble.stop()
	floorChecker.enabled = false
	backChecker.enabled = false
	playerRaycast.enabled = false
	if death_direction == "back":
		# We are flipping the direction... for now.... 
		# Maybe when I have a back death animation i can use that instead
		turn_around()
	animPlayer.play("die")
	label.set_text(death_direction)
