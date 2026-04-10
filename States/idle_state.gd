extends PlayerState

const DECEL_DURATION := 0.75

var _decel_time_left: float = 0.0
var _decel_start_vel: Vector2 = Vector2.ZERO


func enter(_previous_state_path: String, _data := {}) -> void:
	_play_idle_anim()
	if player.velocity.length_squared() > 0.0001:
		_decel_time_left = DECEL_DURATION
		_decel_start_vel = player.velocity
	else:
		_decel_time_left = 0.0
		player.velocity = Vector2.ZERO


func physics_update(delta: float) -> void:
	if _decel_time_left > 0.0:
		_decel_time_left -= delta
		# Fraction of DECEL_DURATION elapsed → proportional blend to zero (same as linear t over time).
		var t := 1.0 - clampf(_decel_time_left / DECEL_DURATION, 0.0, 1.0)
		player.velocity = _decel_start_vel.lerp(Vector2.ZERO, t)
		if _decel_time_left <= 0.0:
			player.velocity = Vector2.ZERO
	else:
		player.velocity = Vector2.ZERO


func _play_idle_anim() -> void:
	var ap := player.animation_player
	if player.enraged:
		ap.play("enrage_idle")
	else:
		ap.play("idle")
