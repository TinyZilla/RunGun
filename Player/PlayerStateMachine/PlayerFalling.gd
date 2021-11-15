extends "res://Player/PlayerStateMachine/PlayerState.gd"

func enter(init_arg: Dictionary = {}) -> void:
	velocity = init_arg.get("velocity", Vector2.ZERO)
	
	Player.movementSprite.play("fall")

func do_state_logic(_delta: float) -> void:
	velocity = add_horizontal_velocity(velocity, get_horizontal_direction())
	velocity = add_falling_gravity(velocity)
	velocity = Player.move_and_slide(velocity, Vector2.UP)

func check_for_new_state() -> String:
	if not Player.is_on_floor():
		return "falling"
	return "idle"
