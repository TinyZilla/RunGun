extends Area2D

export(String) var hit_area = "front"
export(int) var damage_multiplier = 1

func hit(incoming_damage: int) -> void:
	var _owner = get_owner()
	_owner.death_direction = hit_area
	_owner.get_health().take_damage(incoming_damage * damage_multiplier)
