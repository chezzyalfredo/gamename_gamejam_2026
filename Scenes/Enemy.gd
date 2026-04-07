class_name Enemy extends Node2D

var tranq_cd :float = 8.0
var tranq_delta :float = 1.5
var tranq_on_cd : bool = true
var player = null
var speed = 75
var start_delay:float = 5.0

signal tranq_shot

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var rng = RandomNumberGenerator.new()
	start_delay = rng.randf_range(start_delay*0.8, start_delay*2.0)
	await get_tree().create_timer(start_delay).timeout
	tranq_on_cd = false

func _process(_delta) -> void:
	if not tranq_on_cd:
		shoot_tranq()

## Called when the player’s interaction area overlaps this enemy (placeholder).
func placeholder_player_interaction(_player: Player) -> void:
	print(name)

func enemy_attacked(_player: Player) -> void:
	print(name, " was attacked and killed")
	self.queue_free()

func move_enemy() -> void:
	#var direction = (player.global_position - global_position).normalized()
	pass

func shoot_tranq() -> void:
	if tranq_on_cd:
		return
	# shoot tranq towards player
	var direction = (player.global_position - global_position).normalized()
	var tranq = preload("res://Scenes/Tranquilizer.tscn").instantiate()
	get_tree().current_scene.add_child(tranq)
	tranq.global_position = global_position
	tranq.velocity = direction * speed
	var rng = RandomNumberGenerator.new()
	tranq_cd = rng.randf_range(tranq_cd - tranq_delta, tranq_cd + tranq_delta)
	speed = rng.randi_range(75,150)
	tranq_shot.emit()

func _on_tranq_shot() -> void:
	tranq_on_cd = true
	await get_tree().create_timer(tranq_cd).timeout
	tranq_on_cd = false
