extends Area2D


func hit(incoming_damage: int) -> void:
	get_owner().get_health().take_damage(incoming_damage)
