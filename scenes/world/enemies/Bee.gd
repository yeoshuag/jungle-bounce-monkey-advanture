extends EnemyBase
class_name Bee

const SPEED := 90.0
const AMPLITUDE := 40.0
const FREQUENCY := 3.0
const EDGE_MARGIN := 40.0

var base_position: Vector2 = Vector2.ZERO
var t: float = 0.0
var direction: int = 1
var screen_width: float = 720.0

func _ready() -> void:
	super._ready()
	screen_width = get_viewport_rect().size.x

func activate(pos: Vector2) -> void:
	super.activate(pos)
	base_position = pos
	t = randf() * TAU
	direction = 1 if randf() < 0.5 else -1

func _process(delta: float) -> void:
	if not active:
		return
	t += delta * FREQUENCY
	base_position.x += SPEED * direction * delta
	if base_position.x < EDGE_MARGIN:
		base_position.x = EDGE_MARGIN
		direction = 1
	elif base_position.x > screen_width - EDGE_MARGIN:
		base_position.x = screen_width - EDGE_MARGIN
		direction = -1
	position = base_position + Vector2(0, sin(t) * AMPLITUDE)
	rotation = cos(t) * 0.1

func _draw() -> void:
	draw_line(Vector2(-14, -10), Vector2(0, -16), Color(0.9, 0.9, 1.0, 0.7), 6.0)
	draw_line(Vector2(14, -10), Vector2(0, -16), Color(0.9, 0.9, 1.0, 0.7), 6.0)
	draw_circle(Vector2.ZERO, 12.0, Color(1.0, 0.85, 0.1))
	draw_circle(Vector2(-6, 0), 4.0, Color(0.1, 0.1, 0.1))
	draw_circle(Vector2(6, 0), 4.0, Color(0.1, 0.1, 0.1))
