extends PowerupBase
class_name DoubleJumpPowerup

const DURATION := 8.0

func _apply_effect(_player: Player) -> void:
	GameManager.activate_double_jump(DURATION)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 22.0, Color(1.0, 0.5, 0.1, 0.9))
	var pts := PackedVector2Array([
		Vector2(0, -14), Vector2(-10, 4), Vector2(-4, 4),
		Vector2(-4, 14), Vector2(4, 14), Vector2(4, 4), Vector2(10, 4),
	])
	draw_colored_polygon(pts, Color(1, 1, 1, 0.95))
