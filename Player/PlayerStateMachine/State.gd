extends Node

func do_state_logic(_delta: float) -> void:
	pass

func check_for_new_state() -> String:
	return self.name

func exit() -> Dictionary:
	return {}

func enter(_init_arg: Dictionary = {}) -> void:
	pass

func _on_animation_finished() -> void:
	pass
