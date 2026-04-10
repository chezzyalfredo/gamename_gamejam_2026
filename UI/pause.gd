extends ColorRect
@onready var ap : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	ap.set_autoplay("bearitrice_pause")
	if ap.current_animation != "bearitrice_pause":
		ap.play("bearitrice_pause")

func _process(_delta: float) -> void:
	if ap.current_animation != "bearitrice_pause":
		ap.play("bearitrice_pause")
