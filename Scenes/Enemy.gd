class_name Enemy extends Node2D

var tranq_cd :float = 8.0
var tranq_delta :float = 1.5
var projectile_on_cd : bool = true
var bola_cd :float = 10.0
var bola_delta : float = 2.0
var player = null
var speed = 75
var start_delay:float = 5.0
var rng := RandomNumberGenerator.new()
var enemy_velocity := 50
var mobile_hunter : bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	start_delay = rng.randf_range(start_delay*0.8, start_delay*2.0)
	await get_tree().create_timer(start_delay).timeout
	projectile_on_cd = false
	if rng.randi_range(0, 10) == 0:
		mobile_hunter = true

func _process(delta) -> void:
	if not projectile_on_cd:
		var i = rng.randi_range(0, 2)
		if i == 0:
			shoot_bola()
		else:
			shoot_tranq()
	if mobile_hunter and not player.caught:
		global_position += move_enemy() * delta * enemy_velocity

## Called when the player’s interaction area overlaps this enemy (placeholder).
func placeholder_player_interaction(_p: Player) -> void:
	print(name)
	self.queue_free()

func enemy_attacked(_player: Player) -> void:
	print(name, " was attacked and killed")
	self.queue_free()

func move_enemy() -> Vector2:
	return (player.global_position - global_position).normalized()

func shoot_tranq() -> void:
	if projectile_on_cd:
		return
	# shoot tranq towards player
	var player_pos = player.global_position.round()
	var direction = (player_pos - global_position).normalized()
	var tranq = preload("res://Scenes/Tranquilizer.tscn").instantiate()
	get_tree().current_scene.add_child(tranq)
	tranq.global_position = global_position
	tranq.velocity = direction * speed
	var tmp_cd = rng.randf_range(tranq_cd - tranq_delta, tranq_cd + tranq_delta)
	speed = rng.randi_range(75,150)
	_on_projectile_shot(tmp_cd)

func shoot_bola() -> void:
	if projectile_on_cd:
		return
	# shoot bola towards player
	var player_pos = player.global_position.round()
	var direction = (player_pos - global_position).normalized()
	var bola = preload("res://Scenes/Bola.tscn").instantiate()
	get_tree().current_scene.add_child(bola)
	bola.global_position = global_position
	bola.velocity = direction * speed
	var tmp_cd = rng.randf_range(bola_cd - bola_delta, bola_cd + bola_delta)
	speed = rng.randi_range(75,150)
	_on_projectile_shot(tmp_cd)

func _on_projectile_shot(cd: float) -> void:
	projectile_on_cd = true
	await get_tree().create_timer(cd).timeout
	projectile_on_cd = false
