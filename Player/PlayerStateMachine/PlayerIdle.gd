extends "res://Player/PlayerStateMachine/PlayerState.gd"

func enter(init_arg: Dictionary = {}):
	velocity = init_arg.get("velocity", Vector2.ZERO)
	# Set the animation to Idle (if I have an animator)
	Player.movementSprite.play("idle")

func do_state_logic(_delta: float) -> void:
	velocity = add_horizontal_velocity(velocity, 0)
	velocity = add_falling_gravity(velocity)
	velocity = Player.move_and_slide(velocity, Vector2.UP, true)

func check_for_new_state() -> String:
	if Input.is_action_pressed("jump"):
		return "jumping"
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return "running"
	return "idle"
