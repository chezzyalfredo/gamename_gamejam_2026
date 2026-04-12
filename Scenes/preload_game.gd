extends Control

@onready var ani_player := $AnimationPlayer

func _ready() -> void:
	ani_player.play("show_signature")
	await ani_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
