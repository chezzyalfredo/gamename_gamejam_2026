class_name Play_Map extends Node2D

const plus_min: = Vector2i(35, 30)
const tile_size: = Vector2i(32, 32)
const quadrant:= [Vector2i(-1,-1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1)]


func min_max_x() -> Array:
	var x = plus_min.x * tile_size.x
	return [-1*x, x]

func min_max_y() -> Array:
	var y = plus_min.y * tile_size.y
	return [-1*y, y]
