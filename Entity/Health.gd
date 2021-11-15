extends Node

signal fatal_damage

# For Initializing Health Nodes
export(int) var hp_max: int = 10
export(int) var hp: int = hp_max

func take_damage(damage: int) -> void:
	if damage >= hp:
		emit_signal("fatal_damage")
	else:
		hp -= damage
