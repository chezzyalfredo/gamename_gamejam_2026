class_name Enemy extends Node2D

## Called when the player’s interaction area overlaps this enemy (placeholder).
func placeholder_player_interaction(_player: Player) -> void:
	print(name)
	pass
	
func enemy_attacked(_player: Player) -> void:
	print(name, " was attacked and killed")
	self.queue_free()
	pass
