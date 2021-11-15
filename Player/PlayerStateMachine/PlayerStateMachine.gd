extends Node

var current_state = "idle"

onready var state_list = \
{
	"idle": get_node("idle"),
	"running": get_node("running"),
	"jumping": get_node("jumping"),
	"falling": get_node("falling")
}

# Setup for the state machine.
func init() -> void:
	state_list[current_state].enter()

# Update function.
func _physics_process(delta: float) -> void:
	state_list[current_state].do_state_logic(delta)
	try_state_transition()

# State Transition Handling.
func try_state_transition():
	var next_state = state_list[current_state].check_for_new_state()
	
	# Assertion Make sure everything runs smoothly.
	assert(state_list.keys().has(next_state))
	
	if next_state != current_state:
		var init_arg = state_list[current_state].exit()
		state_list[next_state].enter(init_arg)
		current_state = next_state
		
		# For Debug Purposes, Display current state as a text
		owner.get_node("StateLabel").text = current_state

func _on_animation_finished() -> void:
	state_list[current_state]._on_animation_finished()
