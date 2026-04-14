class_name Game_Over extends Control

const META_FINAL_SCORE := &"pending_game_over_score"
const META_FINAL_TIME := &"pending_game_over_time"

@onready var bearitrice = $Bearitrice
@onready var ap = $AnimationPlayer
@onready var game_over_text = $Game_Over_Text
@onready var score_label: RichTextLabel = $Score
@onready var time_label: RichTextLabel = $Time_Elapsed


func _ready() -> void:
	var final_score: Variant = get_tree().root.get_meta(META_FINAL_SCORE, 0.0)
	var final_time: Variant = get_tree().root.get_meta(META_FINAL_TIME, 0.0)
	score_label.text = "Score: %s" % str(("%.0f" % final_score))
	time_label.text = "Time Elapsed: %s seconds" % str(("%.0f" % final_time))
	if get_tree().root.has_meta(META_FINAL_SCORE):
		get_tree().root.remove_meta(META_FINAL_SCORE)
	if get_tree().root.has_meta(META_FINAL_TIME):
		get_tree().root.remove_meta(META_FINAL_TIME)

func _process(_delta: float) -> void:
	ap.play("bearitrice_freakout")


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Play_Game.tscn")


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
