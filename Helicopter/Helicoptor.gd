extends "res://Entity/EntityBase.gd"

signal boss_died

export(NodePath) var playerPath
var active: bool = false setget set_active
var _is_dead: bool = false

const HELI_BOMBS: PackedScene = preload("res://Helicopter/Bomb/HeliBomb.tscn")

onready var player = get_node(playerPath)
onready var bombDropTimer = get_node("BombDropTimer")

func _physics_process(delta: float) -> void:
	if active:
		
		var offset = player.global_position.x - self.global_position.x
		var direction = sign(offset)

		offset = abs(offset)
		if offset < 20:
			offset = 0
		
		velocity.x = direction * min(horizontal_speed * offset, horizontal_speed)

	if not _is_dead:
		velocity.y = sin(OS.get_ticks_msec() / 200.0) * 8.0
	else:
		velocity.y = min(velocity.y + 200 * delta, 180)
	
	velocity = move_and_slide(velocity)

func set_active(is_active: bool) -> void:
	active = is_active
	if active:
		bombDropTimer.start()
	else:
		bombDropTimer.stop()

func _on_BombDropTimer_timeout() -> void:
	for _i in range(3):
		var heliBomb = HELI_BOMBS.instance()
	
		# Update bullet rotation & Direction.
		heliBomb.position = global_position
		get_tree().get_root().add_child(heliBomb)
		yield(get_tree().create_timer(0.3), "timeout")

func die() -> void:
	self.active = false
	_is_dead = true
	velocity.y = 0
	velocity.x = 0
	z_index = -2
	get_node("AnimatedSprite").stop()
	get_node("Hurtbox/CollisionPolygon2D").set_deferred("disabled", true)
	emit_signal("boss_died")
	#queue_free()
