class_name Player extends Node2D

var velocity := Vector2.ZERO
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return
	if _is_enrage_key(event as InputEventKey):
		$StateMachine/Move_State.toggle_enrage()
	if not _is_arrow_key(event as InputEventKey):
		return
	if state_machine.state.name != PlayerState.IDLE:
		return
	state_machine.transition_to(PlayerState.MOVE)


func _is_arrow_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT:
			return true
		_:
			return false

func _is_enrage_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_SPACE:
			return true
		_:
			return false

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	global_position = global_position.round()
