class_name Tranquilizer extends CharacterBody2D

func _ready() -> void:
	await get_tree().create_timer(30).timeout
	score_queue_free()

func _physics_process(delta: float) -> void:
	rotation = velocity.angle() + PI / 2
	var collision = move_and_collide(velocity*delta)
	if collision:
		var body = collision.get_collider()
		if body.is_in_group("player"):
			body.hit_by_tranquilizer(self)
			queue_free()
		if body.is_in_group("map"):
			score_queue_free()
	
	if position.length() > 2500:
		score_queue_free()

func score_queue_free() -> void:
	var sk := get_tree().get_first_node_in_group("game_score") as Score
	if sk:
		sk.update_score(1.0)
	queue_free()
