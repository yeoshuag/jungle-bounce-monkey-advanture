extends PowerupBase
class_name ShieldPowerup

const DURATION := 6.0

func _apply_effect(player: Player) -> void:
	player.apply_shield(DURATION)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 22.0, Color(0.3, 0.7, 1.0, 0.9))
	draw_arc(Vector2.ZERO, 12.0, 0.0, TAU, 24, Color(1, 1, 1, 0.9), 3.0, true)
