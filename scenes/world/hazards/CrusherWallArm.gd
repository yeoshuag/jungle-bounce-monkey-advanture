extends Area2D
class_name CrusherWallArm

@export var spike_direction: int = 1

const WIDTH := 38.0
const HEIGHT := 140.0
const SPIKE_LENGTH := 12.0

func _ready() -> void:
	add_to_group("hazard")

func _draw() -> void:
	draw_rect(Rect2(-WIDTH / 2.0, -HEIGHT / 2.0, WIDTH, HEIGHT), Color(0.4, 0.42, 0.45), true)
	var spike_count := 4
	var segment: float = HEIGHT / spike_count
	var spike_half_height: float = segment * 0.4
	var edge_x: float = (WIDTH / 2.0) * spike_direction
	var tip_x: float = edge_x + SPIKE_LENGTH * spike_direction
	for i in range(spike_count):
		var y: float = -HEIGHT / 2.0 + segment * (i + 0.5)
		var pts := PackedVector2Array([
			Vector2(edge_x, y - spike_half_height),
			Vector2(tip_x, y),
			Vector2(edge_x, y + spike_half_height),
		])
		draw_colored_polygon(pts, Color(0.75, 0.15, 0.15))
