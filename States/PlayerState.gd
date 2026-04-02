class_name PlayerState extends State

const IDLE = "Idle_State"
const MOVE = "Move_State"
const ENRAGE = "Enrage_State"
#const ATTACK = "Attack_State"

var player : Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "Owner Node MUST BE a Player Node otherwise errors will occur")
