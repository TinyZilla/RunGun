extends Camera2D

onready var player = get_owner().get_node("Player")

func _process(delta: float) -> void:
	position = player.position
