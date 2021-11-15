extends "res://Player/PlayerStateMachine/State.gd"

onready var Player = self.get_owner()

var velocity = Vector2()

func add_falling_gravity(_velocity: Vector2) -> Vector2:
	_velocity.y += Player.fall_gravity * get_physics_process_delta_time()
	return _velocity

func add_jumping_gravity(_velocity: Vector2) -> Vector2:
	_velocity.y += Player.jump_gravity * get_physics_process_delta_time()
	return _velocity

func add_horizontal_velocity(_velocity: Vector2, direction: float = 1) -> Vector2:
	if direction != 0:
		_velocity.x = lerp(velocity.x, Player.horizontal_speed * direction, Player.acceleration)
	else:
		_velocity.x = lerp(velocity.x, 0, Player.friction)
	return _velocity

func get_horizontal_direction() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")
