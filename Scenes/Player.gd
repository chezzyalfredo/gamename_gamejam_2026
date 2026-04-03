class_name Player extends Node2D

var velocity := Vector2.ZERO
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var dir_indicator: Sprite2D = $"Directional Indicator"
@onready var interaction_area: Area2D = $InteractionArea
@onready var attack_hitbox: Area2D = $"Directional Indicator/ClawAttack/Attack_Hitbox"
@onready var claw_attack := $"Directional Indicator/ClawAttack"
var attack_cd: bool = false


func _ready() -> void:
	interaction_area.area_entered.connect(_on_interaction_area_area_entered)
	attack_hitbox.area_entered.connect(_on_attack_hitbox_area_entered)

func _on_interaction_area_area_entered(area: Area2D) -> void:
	var enemy := _enemy_from_area(area)
	print(enemy, "interaction area entered")
	if enemy:
		_on_player_enemy_overlap(enemy)

func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	var enemy := _enemy_from_area(area)
	print(enemy, "attack area entered")
	if enemy:
		_on_player_enemy_attacked(enemy)

func _enemy_from_area(area: Area2D) -> Enemy:
	var n: Node = area
	while n:
		print( "Node:", n, "| Script:", n.get_script(), "| Class:", n.get_class(), "| is Enemy:", n is Enemy)
		if n is Enemy:
			return n as Enemy
		n = n.get_parent()
	return null

func _on_player_enemy_overlap(enemy: Enemy) -> void:
	print(enemy, " entered")
	enemy.placeholder_player_interaction(self)

func _on_player_enemy_attacked(enemy: Enemy) -> void:
	enemy.enemy_attacked(self)

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return
	if _is_pause_key(event as InputEventKey):
		print("pause key pressed")
		return
	if _is_reset_key(event as InputEventKey):
		print("reset key pressed")
		return
	if _is_enrage_key(event as InputEventKey):
		$StateMachine/Move_State.toggle_enrage()
		return
	if _is_attack_key(event as InputEventKey) and not attack_cd:
		_use_attack()
		return
	if not _is_arrow_key(event as InputEventKey):
		return
	if state_machine.state.name != PlayerState.IDLE:
		return
	state_machine.transition_to(PlayerState.MOVE)


func _is_arrow_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT:
			return true
		_:
			return false

func _is_enrage_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_SPACE:
			return true
		_:
			return false

func _is_reset_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_R:
			return true
		_:
			return false

func _is_pause_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_ESCAPE:
			return true
		_:
			return false

func _is_attack_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_X:
			return true
		_:
			return false

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	global_position = global_position.round()

var attack_visible_time: float = 0.1
func _use_attack() -> void:
	claw_attack.visible = true
	$"Directional Indicator/ClawAttack/Attack_Hitbox".monitoring = true
	await get_tree().create_timer(attack_visible_time).timeout
	claw_attack.visible = false
	$"Directional Indicator/ClawAttack/Attack_Hitbox".monitoring = false
	attack_cooldown_init()

var attack_cd_timer: float = 0.5
func attack_cooldown_init() -> void:
	attack_cd = true
	await get_tree().create_timer(attack_cd_timer).timeout
	attack_cd = false
