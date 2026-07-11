extends PlatformBase
class_name IcePlatform

const ICE_SLIDE_DURATION := 1.2

func on_player_bounce(player: Node) -> float:
	if player.has_method("apply_ice_slide"):
		player.apply_ice_slide(ICE_SLIDE_DURATION)
	return jump_force

func _draw() -> void:
	draw_rect(Rect2(-width / 2.0, -10, width, 20), Color(0.65, 0.85, 0.95) * tint, true)
	draw_rect(Rect2(-width / 2.0, -10, width, 6), Color(0.88, 0.96, 1.0) * tint, true)
