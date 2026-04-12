class_name StateMachine extends Node

@export var init_state: State = null

@onready var state: State = (
	func get_initial_state() -> State:
		if init_state != null:
			return init_state
		else:
			return get_child(0)
).call()

func _ready() -> void:
	# Run before Player._physics_process so velocity is updated before integration.
	process_priority = 10
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)

	await owner.ready
	state.enter("")


# Switch to another state by node name (e.g. PlayerState.MOVE). No-op if already there.
func transition_to(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name, ": Trying to transition to state ", target_state_path, " but it does not exist.")
		return
	if state.name == target_state_path:
		return
	_transition_to_next_state(target_state_path, data)


func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name, ": Trying to transition to state ", target_state_path, " but it does not exist.")
		return
	
	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)
