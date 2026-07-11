extends PlatformBase
class_name GoldenPlatform

const BONUS_BANANAS := 3

func on_player_bounce(_player: Node) -> float:
	GameManager.collect_banana(BONUS_BANANAS)
	return jump_force

func _draw() -> void:
	draw_rect(Rect2(-width / 2.0, -10, width, 20), Color(0.95, 0.8, 0.2) * tint, true)
	draw_rect(Rect2(-width / 2.0, -10, width, 6), Color(1.0, 0.92, 0.5) * tint, true)
