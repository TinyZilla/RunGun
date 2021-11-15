extends Node2D

onready var mainCamera = get_node("MainCamera")
onready var playerCamDetector = get_node("PlayerCamDetector")
onready var playerDetector = get_node("PlayerDetector")
onready var player = get_node("Player")
onready var tween = get_node("Tween")
onready var heli = get_node("Helicoptor")
onready var LevelEndTimer = get_node("LevelEndTimer")
onready var gameMenu = get_node("GUI/GameMenu")
onready var endMenu = get_node("GUI/EndMenu")

func _ready() -> void:
	mainCamera.limit_left = 0
	gameMenu.visible = false
	endMenu.visible = false

func _on_PlayerDetector_area_entered(_area: Area2D) -> void:
	playerDetector.queue_free()
	
	mainCamera.drag_margin_h_enabled = false
	mainCamera.drag_margin_bottom = 0.4
	tween.interpolate_property(mainCamera, "offset_h", mainCamera.offset_h, 0, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(mainCamera, "offset", Vector2.ZERO, Vector2(0, -20), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	heli.visible = true
	heli.active = true
	var heli_init_pos = heli.position.y
	heli_init_pos = heli_init_pos - 60
	tween.interpolate_property(heli, "position:y", heli_init_pos, heli.position.y, 3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

	tween.start()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	playerCamDetector.queue_free()
	mainCamera.limit_left = playerCamDetector.global_position.x


func _on_Helicoptor_boss_died() -> void:
	player.stop_controls()
	LevelEndTimer.start()

func _on_Player_player_died() -> void:
	if not endMenu.visible:
		yield(get_tree().create_timer(1.3), "timeout")
		gameMenu.visible = true
	

func _on_LevelEndTimer_timeout() -> void:
	# End the game here
	if not gameMenu.visible:
		endMenu.visible = true


func _on_Killzone_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit(1000)


func _on_Retry_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_Main_Menu_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")
	pass # Replace with function body.
