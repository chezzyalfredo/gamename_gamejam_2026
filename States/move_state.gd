extends PlayerState

var MAX_SPEED := 200.0
const RAGE_SPEED := 200.0
# constant rate of increase/decrease not percentage based.
const MOVE_ACCEL := 1000.0
var enraged : bool = false

func enter(_previous_state_path: String, _data := {}) -> void:
	#var ap := player.animation_player
	#if ap and ap.has_animation("walk"):
		#ap.play("walk")
	pass

func physics_update(delta: float) -> void:
	if player.caught or player.pending_caught_sequence:
		player.velocity = Vector2.ZERO
		return
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if !Input.is_anything_pressed():
		finished.emit(PlayerState.IDLE, {})
		return
	if input_dir.length_squared() > 0.0001 and player.dir_indicator:
		# Texture points up at rotation 0; +PI/2 aligns angle() (from +X) with that default.
		player.dir_indicator.rotation = input_dir.angle() + PI * 0.5
		update_animation(input_dir)
			
	var desired := input_dir * MAX_SPEED
	player.velocity.x = move_toward(player.velocity.x, desired.x, MOVE_ACCEL * delta)
	player.velocity.y = move_toward(player.velocity.y, desired.y, MOVE_ACCEL * delta)

func toggle_enrage(e: bool) -> void:
	if !e:
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
	player.velocity = Vector2.ZERO
	

func update_animation(input_dir: Vector2) -> void:
	if player.animation_locked:
		return
	var anim := "walk_left"
	if enraged:
		anim = "enrage_left"
	if input_dir.y < -0.1:
		if enraged:
			anim = "enrage_back"
		else:
			anim = "walk_back"
	elif input_dir.x < -0.1:
		if enraged:
			anim = "enrage_left"
		else:
			anim = "walk_left"
	elif input_dir.x > 0.1:
		if enraged:
			anim = "enrage_right"
		else:
			anim = "walk_right"
	if player.animation_player.current_animation != anim:
		player.animation_player.play(anim)
