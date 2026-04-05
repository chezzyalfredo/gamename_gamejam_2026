class_name Escape_Sequencer extends Control

enum Direction {UP, DOWN, LEFT, RIGHT}

var escape_sequence: Array = []
var current_step:int = 0
var sequence_size:int = 4 #inputs
var sequence_time:float = 3.0 #seconds
var increment_size: int = 1
var increment_time: float = 0.75
var timer: Timer = Timer.new() # TODO
@onready var grid: GridContainer = $GridContainer
const ARROW_SCENE = preload("res://UI/Escape_Arrow.tscn")
var visual_step: int = 0
var resetting_sequence:bool = false

signal escaped()

func _process(_delta: float) -> void:
	if escape_sequence.size() > 0 and current_step > 0 and current_step >= escape_sequence.size():
		current_step = 0
		escaped.emit()
		sequence_size += increment_size
		sequence_time += increment_time
		print("escaped!")
		escape_sequence = []

func generate_sequence() -> void:
	print("generate sequence")
	escape_sequence = []
	for i in range(sequence_size):
		var rng = RandomNumberGenerator.new()
		var direction = rng.randi_range(0,3)
		escape_sequence.append(direction)
	reset_sequence_sprites()
	print("sequence_size:", sequence_size, " escape_sequence:", escape_sequence, " sequence_time:", sequence_time)
	print(Direction.UP, " ", Direction.DOWN, " ", Direction.LEFT, " ", Direction.RIGHT)

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return
	if escape_sequence.size() <= 0:
		return
	if current_step > escape_sequence.size():
		return
	if escape_sequence[current_step] == Direction.UP:
		print("current_step:", current_step, " await:", escape_sequence[current_step])
		if wait_for_up(event as InputEventKey):
			next_in_sequence()
		else:
			reset_sequence_sprites()
			# reset all sprites to the non-input versions
		return
	if escape_sequence[current_step] == Direction.DOWN:
		print("current_step:", current_step, " await:", escape_sequence[current_step])
		if wait_for_down(event as InputEventKey):
			next_in_sequence()
		else:
			reset_sequence_sprites()
			# reset all sprites to the non-input versions
		return
	if escape_sequence[current_step] == Direction.LEFT:
		print("current_step:", current_step, " await:", escape_sequence[current_step])
		if wait_for_left(event as InputEventKey):
			next_in_sequence()
		else:
			reset_sequence_sprites()
			# reset all sprites to the non-input versions
		return
	if escape_sequence[current_step] == Direction.RIGHT:
		print("current_step:", current_step, " await:", escape_sequence[current_step])
		if wait_for_right(event as InputEventKey):
			next_in_sequence()
		else:
			reset_sequence_sprites()
			# reset all sprites to the non-input versions
		return

func next_in_sequence() -> void:
	var arrow :Escape_Arrow = grid.get_children().get(visual_step)
	arrow.set_direction_correct()
	current_step += 1
	visual_step += 1

func reset_sequence_sprites() -> void:
	current_step = 0
	await clear_grid()
	
	visual_step = 0
	for dir in escape_sequence:
		var arrow = ARROW_SCENE.instantiate()
		grid.add_child(arrow)
		arrow.set_direction(dir)

func clear_grid() -> void:
	for n in grid.get_children():
		n.queue_free()
	await get_tree().process_frame

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


func _on_grid_container_child_exiting_tree(_node: Node) -> void:
	visual_step = maxi(visual_step - 1, 0)
