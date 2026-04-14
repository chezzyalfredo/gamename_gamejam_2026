class_name Escape_Arrow extends Control

enum Direction {UP, DOWN, LEFT, RIGHT}

var direction : Direction
@onready var arrow_sprite : Sprite2D = $Arrow_Sprite
var arrow_timeout:float = 1.75

func set_direction(dir: int) -> void:
	direction = (dir % 4) as Direction # using %4 to avoid bad assignment
	set_direction_default()

func set_direction_default() -> void:
	arrow_sprite.frame_coords = Vector2i(direction, 0)

func set_direction_correct() -> void:
	arrow_sprite.frame_coords = Vector2i(direction, 1)

func set_direction_current() -> void:
	arrow_sprite.frame_coords = Vector2i(direction, 2)
