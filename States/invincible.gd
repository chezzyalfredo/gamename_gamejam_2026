extends Node



var invincible_state : bool = false

# when invincible - ignore damage checks
# still need to check lose condition

func _process(_delta: float) -> void:
	pass
	# turn on the shader to note invincible

func on_invincible() -> void:
	invincible_state = true

func off_invincible() -> void:
	invincible_state = false

func toggle_invincible() -> void :
	invincible_state = !invincible_state

func is_invincible() -> bool:
	return invincible_state
