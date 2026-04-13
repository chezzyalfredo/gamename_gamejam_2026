class_name Player extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var dir_indicator: Sprite2D = $"Directional Indicator"
@onready var interaction_area: Area2D = $InteractionArea
@onready var attack_hitbox: Area2D = $"Directional Indicator/ClawAttack/Attack_Hitbox"
@onready var claw_attack := $"Directional Indicator/ClawAttack"
@onready var ui := $UserInterface
@onready var play_map: Play_Map = $"../Play_Map"
var attack_cd: bool = false
var enraged: bool = false
var caught: bool = false
var animation_locked: bool = false
var enrage_limit_max :int = 5
var enrage_limit :int = 5

func _ready() -> void:
	interaction_area.area_entered.connect(_on_interaction_area_area_entered)
	attack_hitbox.area_entered.connect(_on_attack_hitbox_area_entered)
	global_position = Vector2.ZERO
	ui.update_enrage(enrage_limit)

func _on_interaction_area_area_entered(area: Area2D) -> void:
	var enemy := _enemy_from_area(area)
	print(enemy, "interaction area entered")
	if enemy:
		_on_player_enemy_overlap(enemy)

var enemy_points := 25.0
func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	var enemy := _enemy_from_area(area)
	print(enemy, "attack area entered")
	if enemy:
		_on_player_enemy_attacked(enemy)
		ui.adjust_score(enemy_points)

func _enemy_from_area(area: Area2D) -> Enemy:
	var n: Node = area
	while n:
		print( "Node:", n, "| Script:", n.get_script(), "| Class:", n.get_class(), "| is Enemy:", n is Enemy)
		if n is Enemy:
			return n as Enemy
		n = n.get_parent()
	return null

var enemy_touched := -20.0
func _on_player_enemy_overlap(enemy: Enemy) -> void:
	print(enemy, " entered")
	enemy.placeholder_player_interaction(self)
	ui.adjust_score(enemy_touched)
	caught_toggle()

func _on_player_enemy_attacked(enemy: Enemy) -> void:
	enemy.enemy_attacked(self)

func _input(event: InputEvent) -> void:
	if caught:
		return
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return
	if _is_reset_key(event as InputEventKey):
		print("reset key pressed")
		get_tree().change_scene_to_file("res://Scenes/Play_Game.tscn")
		return
	if _is_enrage_key(event as InputEventKey):
		enrage_toggle()
		return
	if _is_attack_key(event as InputEventKey) and not attack_cd:
		_use_attack()
		return
	if _is_caught_key(event as InputEventKey):
		caught_toggle()
		return
	if _is_roll_key(event as InputEventKey):
		bearrel_roll()
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

func _is_attack_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_X:
			return true
		_:
			return false

func _is_caught_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_T:
			return true
		_:
			return false

func _is_roll_key(event: InputEventKey) -> bool:
	match event.physical_keycode:
		KEY_Z:
			return true
		_:
			return false

func _physics_process(_delta: float) -> void:
	move_and_slide()
	global_position = global_position.round()
	if rolling and play_map:
		_clamp_to_play_bounds()


func _clamp_to_play_bounds() -> void:
	var r := play_map.get_play_bounds_global()
	var min_x := r.position.x
	var max_x := r.position.x + r.size.x
	var min_y := r.position.y
	var max_y := r.position.y + r.size.y
	global_position = Vector2(
		clampf(global_position.x, min_x, max_x),
		clampf(global_position.y, min_y, max_y)
	).round()

var attack_visible_time: float = 0.2
func _use_attack() -> void:
	if attack_cd:
		return
	animation_locked = true
	if enraged:
		$AnimationPlayer.play("enrage_attack_left")
	else:
		$AnimationPlayer.play("left_attack")
	await get_tree().create_timer(0.1).timeout
	claw_attack.visible = true
	$"Directional Indicator/ClawAttack/Attack_Hitbox".monitoring = true
	await get_tree().create_timer(attack_visible_time).timeout
	claw_attack.visible = false
	$"Directional Indicator/ClawAttack/Attack_Hitbox".monitoring = false
	attack_cooldown_init()
	animation_locked = false

var attack_cd_timer: float = 0.5
func attack_cooldown_init() -> void:
	attack_cd = true
	ui.toggle_attack_disable(attack_cd)
	await get_tree().create_timer(attack_cd_timer).timeout
	attack_cd = false
	ui.toggle_attack_disable(attack_cd)

var enrage_timer := 15.0
func enrage_toggle() -> void:
	if enraged or enrage_limit != 0:
		return
	$StateMachine/Move_State.toggle_enrage(enraged)
	if !enraged:
		enraged = true
		ui.camera_enrage_on()
		ui.enraged_text()
		animation_player.play("enrage_idle")
		await get_tree().create_timer(enrage_timer).timeout
		disable_enrage()

func disable_enrage() -> void:
	$StateMachine/Move_State.toggle_enrage(enraged)
	ui.camera_enrage_off()
	enraged = false
	animation_player.play("idle")
	enrage_limit = enrage_limit_max
	ui.update_enrage(enrage_limit)

func caught_toggle() -> void:
	if caught:
		return
	caught = true
	ui.toggle_sequencer_visibility()
	$AnimationPlayer.play("caught")
	await ui.escape_seq.escaped
	print("no longer caught")
	caught = false
	ui.toggle_sequencer_visibility()
	if !enraged:
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("enrage_idle")

var tranq_penalty := -5.0
func hit_by_tranquilizer(tranq: Tranquilizer) -> void:
	if caught:
		ui.adjust_score(tranq_penalty * 4)
	else:
		ui.adjust_score(tranq_penalty)
	if !enraged:
		enrage_limit = max(0, enrage_limit -1)
		ui.update_enrage(enrage_limit)
	print("Player hit by:", tranq)

var rolling : bool = false
var rolling_cd : bool = false
var roll_speed : float = 800
var roll_duration : float = 0.3
var rolling_cd_time : float = 5.0
var rolling_cd_penalty: float = -10.0
func bearrel_roll() -> void:
	if rolling:
		return
	animation_locked = true
	print(rolling_cd)
	if rolling_cd:
		ui.adjust_score(rolling_cd_penalty)
	rolling = true
	$InteractionArea.monitoring = false
	$CollisionShape2D.disabled = true
	var direction = Vector2.UP.rotated($"Directional Indicator".rotation)
	$AnimationPlayer.play("bearrel_roll")
	velocity = direction * roll_speed
	await get_tree().create_timer(roll_duration).timeout
	velocity = Vector2.ZERO
	rolling = false
	$InteractionArea.monitoring = true
	$CollisionShape2D.disabled = false
	roll_cd_timer()
	animation_locked = false

func roll_cd_timer() -> void:
	print("roll timer debug")
	rolling_cd = true
	ui.toggle_roll_penalty(rolling_cd)
	await get_tree().create_timer(rolling_cd_time).timeout
	rolling_cd = false
	ui.toggle_roll_penalty(rolling_cd)
	
var bola_hit_penalty := -50.0
func hit_by_bola(bola: Bola) -> void:
	if caught:
		ui.adjust_score(bola_hit_penalty)
	else:
		caught_toggle()
	print("Player hit by:", bola)
