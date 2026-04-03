extends PlayerState

var MAX_SPEED := 200.0
const RAGE_SPEED := 350.0
# constant rate of increase/decrease not percentage based.
const MOVE_ACCEL := 1000.0
var enraged := false

func enter(_previous_state_path: String, _data := {}) -> void:
	var ap := player.animation_player
	if ap and ap.has_animation("walk"):
		ap.play("walk")

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if !Input.is_anything_pressed():
		finished.emit(PlayerState.IDLE, {})
		return
	if input_dir.length_squared() > 0.0001 and player.dir_indicator:
		# Texture points up at rotation 0; +PI/2 aligns angle() (from +X) with that default.
		player.dir_indicator.rotation = input_dir.angle() + PI * 0.5
	var desired := input_dir * MAX_SPEED
	player.velocity.x = move_toward(player.velocity.x, desired.x, MOVE_ACCEL * delta)
	player.velocity.y = move_toward(player.velocity.y, desired.y, MOVE_ACCEL * delta)

func toggle_enrage() -> void:
	if !enraged:
		enrage()
		return
	end_enrage()

func enrage() -> void:
	MAX_SPEED += RAGE_SPEED
	enraged = true
	print("ENRAGED")
	
func end_enrage() -> void:
	MAX_SPEED -= RAGE_SPEED
	enraged = false
	print("not enraged")

func exit() -> void:
	print(player.global_position)
