extends PlatformBase
class_name StickyPlatform

@export var sticky_force: float = 420.0

func on_player_bounce(_player: Node) -> float:
	return sticky_force

func _draw() -> void:
	draw_rect(Rect2(-width / 2.0, -10, width, 20), Color(0.75, 0.55, 0.15) * tint, true)
	draw_rect(Rect2(-width / 2.0, -10, width, 6), Color(0.9, 0.75, 0.3) * tint, true)
	draw_circle(Vector2(-width * 0.2, -2), 4.0, Color(0.95, 0.8, 0.25) * tint)
	draw_circle(Vector2(width * 0.15, 2), 3.0, Color(0.95, 0.8, 0.25) * tint)
