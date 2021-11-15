extends Node2D

func _process(_delta: float) -> void:
	var horizontal_direction = float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))
	if abs(horizontal_direction) > 0:
		scale.x = -1 if not horizontal_direction == 1 else 1
