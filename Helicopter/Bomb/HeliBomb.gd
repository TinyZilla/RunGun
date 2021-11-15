extends Area2D

var accel = 200
var max_speed = 180
var damage = 200

var curr_speed = 0

var explode_sound: AudioStream = preload("res://Helicopter/Bomb/explode.ogg")

onready var animSprite = get_node("AnimatedSprite")
onready var colShape = get_node("CollisionShape2D")
onready var hitbox = get_node("Hitbox")
onready var audio = get_node("AudioStreamPlayer2D")

func _physics_process(delta: float) -> void:
	curr_speed = min(curr_speed + delta * accel, max_speed)
	position.y += curr_speed * delta
	pass

func _on_HeliBomb_body_entered(_body: Node) -> void:
	explode()

func explode() -> void:
	set_physics_process(false)
	self.disconnect("body_entered", self, "_on_HeliBomb_body_entered")
	hitbox.get_node("CollisionShape2D").set_deferred("disabled", true)
	animSprite.scale = Vector2(1,1)
	animSprite.play("explode")
	colShape.set_deferred("disabled", true)
	
	audio.set_stream(explode_sound)
	do_damage()
	
	audio.play()
	audio.connect("finished", self, "sudoku")

func do_damage() -> void:
	for area in hitbox.get_overlapping_areas():
		if area.has_method("hit"):
			area.hit(damage)

func sudoku() -> void:
	audio.stop()
	queue_free()
