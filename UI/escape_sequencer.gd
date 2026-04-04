class_name Escape_Sequencer extends Control

enum Direction {UP, DOWN, LEFT, RIGHT}

var escape_sequence: Array = []
var current_step:int = 0

func _process(_delta: float) -> void:
	if current_step >= escape_sequence.size():
		#send free status signal
		pass
	pass

func _input(event: InputEvent) -> void:
	if Direction.UP:
		if wait_for_up(event as InputEventKey):
			current_step += 1
		else:
			current_step = 0
			# reset all sprites to the non-input versions
	if Direction.DOWN:
		if wait_for_down(event as InputEventKey):
			current_step += 1
		else:
			current_step = 0
			# reset all sprites to the non-input versions
	if Direction.LEFT:
		if wait_for_left(event as InputEventKey):
			current_step += 1
		else:
			current_step = 0
			# reset all sprites to the non-input versions
	if Direction.RIGHT:
		if wait_for_right(event as InputEventKey):
			current_step += 1
		else:
			current_step = 0
			# reset all sprites to the non-input versions

func wait_for_up(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_UP:
			return true
		_:
			return false

func wait_for_down(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_DOWN:
			return true
		_:
			return false

func wait_for_left(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_LEFT:
			return true
		_:
			return false

func wait_for_right(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_RIGHT:
			return true
		_:
			return false
