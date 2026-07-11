extends PowerupBase
class_name DoubleBananaPowerup

const DURATION := 8.0

func _apply_effect(_player: Player) -> void:
	GameManager.activate_double_bananas(DURATION)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 22.0, Color(1.0, 0.85, 0.2, 0.9))
	draw_arc(Vector2(-7, 0), 10.0, PI * 0.15, PI * 1.65, 12, Color(0.5, 0.3, 0.0), 4.0, true)
	draw_arc(Vector2(7, 0), 10.0, PI * 0.15, PI * 1.65, 12, Color(0.5, 0.3, 0.0), 4.0, true)
