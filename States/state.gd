class_name State extends Node

# emit when finished and the next state to move to
signal finished(next_state_path: String, data: Dictionary)

# called when receiving input events
func handle_input(_event: InputEvent) -> void:
	pass

# called for main loop tick
func update(_delta: float) -> void:
	pass

# called for physics update tick
func physics_update(_delta: float) -> void:
	pass

# called when changing active state. 'data' is a dictionary with data the state can use to initialize
func enter(previous_state_path: String, data := {}) -> void:
	pass

# called before changing the active state. Clean up state here
func exit() -> void:
	pass
