class_name User_Interface extends Control

@onready var escape_seq := $Stationary/Escape_Sequencer
@onready var camera := $Camera2D
@onready var enrage_filter := $Stationary/Enrage_Red
@onready var pause_screen := $Stationary/Pause

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
