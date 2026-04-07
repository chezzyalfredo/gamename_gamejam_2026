class_name Score extends RichTextLabel

var curr_score :float = 0.0
var game_over :bool = false
var game_paused :bool = false
const score_per_sec := 1.0

func _ready() -> void:
	per_second()

func update_score_label() -> void:
	text = "Score: %s" % str(curr_score)

func update_score(score: float) -> void:
	curr_score += score
	update_score_label()

func per_second() -> void:
	while not game_over:
		await get_tree().create_timer(1.0).timeout
		
		if not game_paused:
			update_score(1)

func pause_toggle() -> void:
	game_paused = not game_paused
