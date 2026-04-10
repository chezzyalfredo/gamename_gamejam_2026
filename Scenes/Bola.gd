class_name Bola extends Area2D

var velocity := Vector2.ZERO


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(30).timeout
	score_queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		(body as Player).hit_by_bola(self)
		queue_free()
	elif body.is_in_group("map"):
		score_queue_free()


func _physics_process(delta: float) -> void:
	rotation += 3*PI / 2.0 * delta
	global_position += velocity * delta
	if global_position.length() > 2500.0:
		score_queue_free()


func score_queue_free() -> void:
	queue_free()
