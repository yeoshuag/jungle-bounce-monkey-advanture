extends PlatformBase
class_name NormalPlatform

func _draw() -> void:
	draw_rect(Rect2(-width / 2.0, -10, width, 20), Color(0.29, 0.55, 0.22), true)
	draw_rect(Rect2(-width / 2.0, -10, width, 6), Color(0.42, 0.72, 0.32), true)
