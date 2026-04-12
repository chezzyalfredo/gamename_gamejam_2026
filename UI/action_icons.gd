class_name action_icons extends Control

@onready var attack_disable := $Attack_Notifier/Disable
@onready var roll_penalty := $Roll_Notifier/Penalty

func show_attack_disabled() -> void:
	attack_disable.visible = true

func show_roll_penalty() -> void:
	roll_penalty.visible = true

func hide_attack_disable() -> void:
	attack_disable.visible = false

func hide_roll_penalty() -> void:
	roll_penalty.visible = false
