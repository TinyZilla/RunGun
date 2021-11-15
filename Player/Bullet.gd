extends Area2D

export(float) var max_range := 1200.0
export(float) var speed := 350.0
export(float) var damage := 10

var _distance_travelled = 0.0

onready var collisionShape = get_node("CollisionShape2D")
onready var sprite = get_node("Sprite")

func _physics_process(delta: float) -> void:
	var distance := speed * delta
	var motion := transform.x * speed * delta
	
	position += motion
	
	_distance_travelled += distance
	if _distance_travelled > max_range:
		disable_bullet()

func disable_bullet() -> void:
	collisionShape.set_deferred("disabled", true)
	sprite.visible = false
	self.set_physics_process(false)
	queue_free()

func _on_AR_Bullet_body_entered(_body: Node) -> void:
	# For Wall Hits
	disable_bullet()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	disable_bullet()

func _on_AR_Bullet_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit(damage)
	disable_bullet()
