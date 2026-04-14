class_name Play_Game extends Node2D

const ENEMY_SCENE := preload("res://Scenes/Enemy.tscn")

var rng := RandomNumberGenerator.new()
@onready var player: Player = $Player
@onready var playmap: Play_Map = $Play_Map
@onready var entities: Node2D = $Entities
const spawnable_distance : float = 128
var hunter_spawn_cd :float = 2.5
var hunter_cd :bool = false
var bush_cd : bool = false
var start_cds : bool = false
var start_hunter_amt : int = 10

signal spawnable
signal hunter_spawned
signal bush_spawned

func _ready() -> void:
	for n in range(start_hunter_amt):
		spawn_hunter()

func _process(_delta: float) -> void:
	start_cds = true
	spawn_hunter()

func get_player_location() -> Vector2i :
	return player.global_position.round()

func spawn_hunter() -> void:
	if hunter_cd:
		return
	var loc := get_spawnable_location()
	var hunter := ENEMY_SCENE.instantiate() as Node2D
	entities.add_child(hunter)
	hunter.global_position = loc
	hunter_spawned.emit()

func spawn_bush() -> void:
	bush_spawned.emit()

func get_spawnable_location() -> Vector2:
	var x_mm := playmap.min_max_x()
	var y_mm := playmap.min_max_y()
	var loc := Vector2i(rng.randi_range(x_mm[0], x_mm[1]), rng.randi_range(y_mm[0], y_mm[1]))
	while not _is_spawnable(loc) :
		loc = Vector2i(rng.randi_range(x_mm[0], x_mm[1]), rng.randi_range(y_mm[0], y_mm[1]))
	return Vector2(loc)

func _is_spawnable(loc_in_q: Vector2i) -> bool:
	var player_loc := get_player_location()
	if player_loc.distance_to(loc_in_q) <= spawnable_distance:
		return false
	else:
		spawnable.emit()
		return true

func _on_hunter_spawned() -> void:
	if start_cds:
		hunter_cd = true
		await get_tree().create_timer(hunter_spawn_cd).timeout
		hunter_cd = false


func _on_bush_spawned() -> void:
	if start_cds:
		bush_cd = true
		await get_tree().create_timer(hunter_spawn_cd).timeout
		bush_cd = false
