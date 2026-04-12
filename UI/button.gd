extends Control

@export var button_text: String = ""
@export var toggle: bool = false
@export var font_size_override: int = -1
@onready var button_label = $Button_Images/Button_Text
@onready var button_img = $Button_Images
var text_position_up = 0
var text_position_down = 0
var text_shift = 0

signal pressed()

func _ready() -> void:
	button_label.text = button_text
	
	button_img.pressed.connect(_on_button_images_pressed)
	button_img.button_down.connect(_on_button_images_button_down)
	button_img.button_up.connect(_on_button_images_button_up)
	button_img.toggle_mode = toggle
	
	text_position_up = button_label.position.y
	text_position_down = button_label.position.y + 4
	if font_size_override > 0:
		button_label.add_theme_font_size_override("font_size", font_size_override)
		text_shift = roundi(font_size_override/4.0)
		text_position_down = text_position_up + text_shift
	print("%s - Text_position_up %s | Text_position_down %s | Text_shift %s" % [button_text, text_position_up, text_position_down, text_shift], "Button.gd")

func set_button_text(text: String) -> void:
	button_text = text
	button_label.text = text

func _on_button_images_pressed() -> void:
	emit_signal("pressed")
	print("%s was pressed" % button_label.text, "button.gd")

func _on_button_images_button_up() -> void:
	print("%s set to up | Toggle state %s | button_pressed state %s" % [button_text, toggle, button_img.button_pressed], "button.gd")
	if not toggle:
		text_bounce_up()

func _on_button_images_button_down() -> void:
	print("%s set to down | Toggle state %s | button_pressed state %s" % [button_text, toggle, button_img.button_pressed], "button.gd")
	if not toggle:
		text_bounce_down()

func text_bounce_up() -> void:
	var txt_pos = button_label.position.y
	button_label.position.y = clamp(txt_pos-text_shift, text_position_up,text_position_up)
	print("[%s] Text Position up: %s" % [button_text, text_position_up] , "Button.gd")

func text_bounce_down() -> void:
	var txt_pos = button_label.position.y
	button_label.position.y = clamp(txt_pos+text_shift, text_position_down, text_position_down)
	print("[%s] Text Position down: %s" % [button_text, text_position_down] , "Button.gd")

# HOW TO USE:
# func _ready():
# 	$MyCustomButton.pressed.connect(_on_custom_button_pressed)
# 
# func _on_custom_button_pressed() -> void:
# 	print("Button was pressed!")
# 	# logic to put here

func _on_button_images_toggled(toggled_on: bool) -> void:
	print("%s set to down | toggled_on bool: %s |Toggle state %s | button_pressed state %s" % [button_text, toggled_on, toggle, $Button_Images.button_pressed], "button.gd")
	if toggled_on:
		text_bounce_down()
	else:
		text_bounce_up()

func get_button_state() -> bool:
	return button_img.button_pressed

func set_button_state(button_state: bool) -> void:
	button_img.button_pressed = button_state
	print("%s state set to: %s" % [button_text, button_state], "Button.gd")
	if button_state:
		text_bounce_down()
	else:
		text_bounce_up()

func disable_button() -> void:
	button_img.disabled = true
	text_bounce_up()
	print("%s button was disabled" % button_text, "Button.gd")

func enable_button() -> void:
	button_img.disabled = false
	print("%s button was enabled" % button_text, "Button.gd")
