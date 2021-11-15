extends Control


func start_game() ->  void:
	get_tree().change_scene("res://Level/Level1.tscn")
	pass
	
func quit_game() -> void:
	get_tree().quit()
	pass
