extends Node2D

func _draw() -> void:
	draw_circle(Vector2.ZERO, 70, Color(0.2, 0.6, 0.25))
	draw_circle(Vector2(-30, -50), 24, Color(0.55, 0.35, 0.2))
	draw_circle(Vector2(30, -50), 24, Color(0.55, 0.35, 0.2))
	draw_circle(Vector2.ZERO, 55, Color(0.55, 0.35, 0.2))
	draw_circle(Vector2(0, 8), 34, Color(0.85, 0.7, 0.55))
	draw_circle(Vector2(-14, -4), 7, Color.BLACK)
	draw_circle(Vector2(14, -4), 7, Color.BLACK)
