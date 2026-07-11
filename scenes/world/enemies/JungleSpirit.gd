extends EnemyBase
class_name JungleSpirit

const DRIFT_SPEED := 30.0
const RADIUS := 50.0

var base_position: Vector2 = Vector2.ZERO
var t: float = 0.0

func activate(pos: Vector2) -> void:
	super.activate(pos)
	base_position = pos
	t = randf() * TAU

func _process(delta: float) -> void:
	if not active:
		return
	t += delta * (DRIFT_SPEED / RADIUS)
	position = base_position + Vector2(cos(t), sin(t) * 0.6) * RADIUS
	modulate.a = 0.5 + 0.5 * sin(t * 1.5)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 16.0, Color(0.5, 0.3, 0.8, 0.8))
	draw_circle(Vector2(-5, -2), 3.0, Color(1, 1, 1, 0.9))
	draw_circle(Vector2(5, -2), 3.0, Color(1, 1, 1, 0.9))
