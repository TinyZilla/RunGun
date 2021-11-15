extends AnimatedSprite

func _process(_delta: float) -> void:
	var horizontal_direction = float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))
	if abs(horizontal_direction) > 0:
		flip_h = not horizontal_direction == 1
