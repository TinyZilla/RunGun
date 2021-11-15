extends Node

var Player
var animTree

var meleeDamage = 20

var area_reference = []

func init():
	Player = get_owner()
	animTree = Player.animTree

var down_buffer := false
var melee_buffer := false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") or event.is_action_released("shoot"):
		if event.is_pressed():
			if melee_buffer:
				animTree["parameters/conditions/can_melee"] = true
				melee_buffer = false
			animTree["parameters/conditions/is_shooting"] = true
			animTree["parameters/conditions/not_is_shooting"] = false
		else:
			animTree["parameters/conditions/is_shooting"] = false
			animTree["parameters/conditions/not_is_shooting"] = true
	if event.is_action_pressed("up") or event.is_action_released("up"):
		if event.is_pressed():
			animTree["parameters/conditions/is_looking_up"] = true
			animTree["parameters/conditions/not_is_looking_up"] = false
		else:
			animTree["parameters/conditions/is_looking_up"] = false
			animTree["parameters/conditions/not_is_looking_up"] = true
	if event.is_action_pressed("down") and not Player.is_on_floor() or event.is_action_released("down"):
		if event.is_pressed():
			animTree["parameters/conditions/is_looking_down"] = true
			animTree["parameters/conditions/not_is_looking_down"] = false
		else:
			animTree["parameters/conditions/is_looking_down"] = false
			animTree["parameters/conditions/not_is_looking_down"] = true
			down_buffer = false
	elif event.is_action_pressed("down") and Player.is_on_floor():
		down_buffer = true

func _process(_delta: float) -> void:
	if down_buffer and not Player.is_on_floor():
		animTree["parameters/conditions/is_looking_down"] = true
		animTree["parameters/conditions/not_is_looking_down"] = false
		down_buffer = false

func doMelee():
	if not area_reference.empty():
		for area in area_reference:
			area.hit(meleeDamage)
	else:
		# Cancel the Melee.. Kinda a hacky fix.. just skip the melee animation all together.
		animTree.advance(3)

func _on_Melee_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area_reference.append(area)
		if area_reference.size() == 1:
			if animTree["parameters/conditions/is_shooting"]:
				animTree["parameters/conditions/can_melee"] = true
			else:
				melee_buffer = true

func _on_Melee_area_exited(area: Area2D) -> void:
	if area.has_method("hit"):
		area_reference.erase(area)
		if area_reference.empty():
			melee_buffer = false
