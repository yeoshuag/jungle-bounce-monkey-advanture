extends Node2D
class_name MonkeySprite

@export var body_color: Color = Color(0.55, 0.35, 0.2)
@export var belly_color: Color = Color(0.85, 0.7, 0.55)

var squash: float = 1.0:
	set(value):
		squash = value
		scale = Vector2(1.0 / value, value)

func _draw() -> void:
	draw_circle(Vector2(-16, -20), 8, body_color)
	draw_circle(Vector2(16, -20), 8, body_color)
	draw_circle(Vector2.ZERO, 18, body_color)
	draw_circle(Vector2(0, 4), 11, belly_color)
	draw_circle(Vector2(-6, -2), 3, Color.BLACK)
	draw_circle(Vector2(6, -2), 3, Color.BLACK)
	draw_circle(Vector2(-3, 8), 1.5, Color.BLACK)
	draw_circle(Vector2(3, 8), 1.5, Color.BLACK)
