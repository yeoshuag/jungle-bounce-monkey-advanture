extends Area2D
class_name CrusherWallArm

@export var spike_direction: int = 1

const WIDTH := 50.0
const HEIGHT := 200.0
const SPIKE_LENGTH := 16.0

func _ready() -> void:
	add_to_group("hazard")

func _draw() -> void:
	draw_rect(Rect2(-WIDTH / 2.0, -HEIGHT / 2.0, WIDTH, HEIGHT), Color(0.4, 0.42, 0.45), true)
	var spike_count := 4
	var edge_x: float = (WIDTH / 2.0) * spike_direction
	var tip_x: float = edge_x + SPIKE_LENGTH * spike_direction
	for i in range(spike_count):
		var y: float = -HEIGHT / 2.0 + HEIGHT * (i + 0.5) / spike_count
		var pts := PackedVector2Array([
			Vector2(edge_x, y - 14),
			Vector2(tip_x, y),
			Vector2(edge_x, y + 14),
		])
		draw_colored_polygon(pts, Color(0.75, 0.15, 0.15))
