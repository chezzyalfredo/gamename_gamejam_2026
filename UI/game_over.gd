class_name Game_Over extends Control

const META_FINAL_SCORE := &"pending_game_over_score"

@onready var bearitrice = $Bearitrice
@onready var ap = $AnimationPlayer
@onready var game_over_text = $Game_Over_Text
@onready var score_label: RichTextLabel = $Score


func _ready() -> void:
	var final_score: Variant = get_tree().root.get_meta(META_FINAL_SCORE, 0.0)
	score_label.text = "Score: %s" % str(final_score)
	if get_tree().root.has_meta(META_FINAL_SCORE):
		get_tree().root.remove_meta(META_FINAL_SCORE)

func _process(_delta: float) -> void:
	ap.play("bearitrice_freakout")


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Play_Game.tscn")
