extends EnemyBase
class_name Snake

const SPEED := 70.0
const RANGE := 90.0

var base_x: float = 0.0
var direction: int = 1

func activate(pos: Vector2) -> void:
	super.activate(pos)
	base_x = pos.x
	direction = 1 if randf() < 0.5 else -1

func _process(delta: float) -> void:
	if not active:
		return
	position.x += SPEED * direction * delta
	if position.x > base_x + RANGE:
		direction = -1
	elif position.x < base_x - RANGE:
		direction = 1
	scale.x = abs(scale.x) * (1 if direction > 0 else -1)

func _draw() -> void:
	draw_rect(Rect2(-16, -6, 32, 12), Color(0.2, 0.55, 0.25), true)
	draw_circle(Vector2(18, 0), 7.0, Color(0.25, 0.6, 0.3))
	draw_circle(Vector2(21, -2), 1.5, Color.BLACK)
