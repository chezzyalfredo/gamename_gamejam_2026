class_name User_Interface extends Control

@onready var escape_seq := $Stationary/Escape_Sequencer
@onready var camera := $Camera2D
@onready var enrage_filter := $Stationary/Enrage_Red
@onready var pause_screen := $Stationary/Pause
@onready var score_text := $Stationary/Score
@onready var action_item := $Stationary/Action_Icons
var player : Player


func _ready() -> void:
	# So Escape still runs while get_tree().paused (Player and the rest of the tree are frozen).
	player = get_tree().get_first_node_in_group("player")
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return
	if event.physical_keycode != KEY_ESCAPE:
		return
	pause_toggle()
	get_viewport().set_input_as_handled()

func toggle_sequencer_visibility() -> void:
	print("toggle sequencer visibility, ", escape_seq.visible)
	if escape_seq.visible:
		escape_seq.visible = false
	else:
		escape_seq.visible = true
		escape_seq.generate_sequence()
	print("toggle sequencer visibility, ", escape_seq.visible)

const camera_default:= Vector2(1.5, 1.5)
const camera_enrage:= Vector2(2.5, 2.5)
func camera_enrage_on() -> void:
	camera.position_smoothing_enabled = false
	camera.zoom = camera_enrage
	enrage_filter.visible = true

func camera_enrage_off() -> void:
	camera.position_smoothing_enabled = true
	camera.zoom = camera_default
	enrage_filter.visible = false

func pause_toggle() -> void:
	pause_screen.visible = not pause_screen.visible
	get_tree().paused = not get_tree().paused
	score_text.pause_toggle()

func adjust_score(amount: float) -> void:
	if player.enraged:
		score_text.update_score(amount * 3)
	else:
		score_text.update_score(amount)

func toggle_attack_disable(disable: bool) -> void:
	if disable:
		action_item.show_attack_disabled()
	else:
		action_item.hide_attack_disable()

func toggle_roll_penalty(penalty: bool) -> void:
	if penalty:
		action_item.show_roll_penalty()
	else:
		action_item.hide_roll_penalty()

func enraged_text() -> void:
	$Stationary/Action_Icons/Enrage_Notifier/Action_Label2.text = "[pulse freq=2 color=red ease=-2.0]ENRAWRRRGED![/pulse]"

func update_enrage(enrage_counter: int) -> void:
	match enrage_counter:
		0: 
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_5.self_modulate = Color(1.0, 1.0, 1.0)
			$Stationary/Action_Icons/Enrage_Notifier/Action_Label2.self_modulate = Color(1.0, 1.0, 1.0)
			$Stationary/Action_Icons/Enrage_Notifier/Action_Label2.text = "[pulse freq=2 color=red ease=-2.0][Space] to ENRAGE![/pulse]"
			$Stationary/Action_Icons/Enrage_Notifier.self_modulate = Color(1.0, 1.0, 1.0)
			return
		1: 
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_4.self_modulate = Color(1.0, 1.0, 1.0)
			return
		2: 
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_3.self_modulate = Color(1.0, 1.0, 1.0)
			return
		3: 
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_2.self_modulate = Color(1.0, 1.0, 1.0)
			return
		4: 
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_1.self_modulate = Color(1.0, 1.0, 1.0)
			return
		5: 
			$Stationary/Action_Icons/Enrage_Notifier/Action_Label2.text = "[Space] to ENRAGE!"
			$Stationary/Action_Icons/Enrage_Notifier.self_modulate = Color(0.475, 0.475, 0.475)
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_1.self_modulate = Color(0.475, 0.475, 0.475)
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_2.self_modulate = Color(0.475, 0.475, 0.475)
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_3.self_modulate = Color(0.475, 0.475, 0.475)
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_4.self_modulate = Color(0.475, 0.475, 0.475)
			$Stationary/Action_Icons/Enrage_Notifier/Tranq_5.self_modulate = Color(0.475, 0.475, 0.475)
			$Stationary/Action_Icons/Enrage_Notifier/Action_Label2.self_modulate = Color(0.475, 0.475, 0.475)
			return
		_:
			return
