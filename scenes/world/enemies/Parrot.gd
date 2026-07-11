extends EnemyBase
class_name Parrot

const SPEED := 160.0
const EDGE_MARGIN := 30.0

var direction: int = 1
var screen_width: float = 720.0

func _ready() -> void:
	super._ready()
	screen_width = get_viewport_rect().size.x

func activate(pos: Vector2) -> void:
	super.activate(pos)
	direction = 1 if randf() < 0.5 else -1

func _process(delta: float) -> void:
	if not active:
		return
	position.x += SPEED * direction * delta
	if position.x < EDGE_MARGIN:
		position.x = EDGE_MARGIN
		direction = 1
	elif position.x > screen_width - EDGE_MARGIN:
		position.x = screen_width - EDGE_MARGIN
		direction = -1
	scale.x = abs(scale.x) * (1 if direction > 0 else -1)

func _draw() -> void:
	draw_line(Vector2(-4, 6), Vector2(-14, 14), Color(0.2, 0.7, 0.3), 5.0)
	draw_circle(Vector2.ZERO, 10.0, Color(0.9, 0.2, 0.2))
	draw_circle(Vector2(8, -2), 5.0, Color(0.2, 0.6, 0.9))
	var pts := PackedVector2Array([Vector2(10, -4), Vector2(20, -2), Vector2(10, 2)])
	draw_colored_polygon(pts, Color(0.95, 0.8, 0.1))
