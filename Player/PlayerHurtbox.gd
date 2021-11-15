extends Area2D


func hit(damage: int) -> void:
	get_owner().get_health().take_damage(damage)
	pass
