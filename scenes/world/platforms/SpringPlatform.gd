extends PlatformBase
class_name SpringPlatform

@export var spring_force: float = 1400.0

func on_player_bounce(_player: Node) -> float:
	return spring_force

func _draw() -> void:
	draw_rect(Rect2(-width / 2.0, -10, width, 20), Color(0.29, 0.55, 0.22), true)
	draw_rect(Rect2(-14, -34, 28, 26), Color(0.75, 0.15, 0.15), true)
	draw_rect(Rect2(-14, -34, 28, 6), Color(0.95, 0.3, 0.3), true)
