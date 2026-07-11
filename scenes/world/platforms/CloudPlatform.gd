extends PlatformBase
class_name CloudPlatform

const H_SPEED := 60.0
const V_AMPLITUDE := 30.0
const V_FREQUENCY := 1.2

var direction: int = 1
var screen_width: float = 720.0
var base_position: Vector2 = Vector2.ZERO
var bob_time: float = 0.0

func _ready() -> void:
	super._ready()
	screen_width = get_viewport_rect().size.x

func activate(pos: Vector2, p_tint: Color = Color(1.0, 1.0, 1.0)) -> void:
	super.activate(pos, p_tint)
	base_position = pos
	direction = 1 if randf() < 0.5 else -1
	bob_time = randf() * TAU

func _physics_process(delta: float) -> void:
	if not active:
		return
	var half_width: float = width / 2.0
	base_position.x += H_SPEED * direction * delta
	if base_position.x < half_width:
		base_position.x = half_width
		direction = 1
	elif base_position.x > screen_width - half_width:
		base_position.x = screen_width - half_width
		direction = -1
	bob_time += delta * V_FREQUENCY
	position.x = base_position.x
	position.y = base_position.y + sin(bob_time) * V_AMPLITUDE

func _draw() -> void:
	draw_rect(Rect2(-width / 2.0, -10, width, 20), Color(0.95, 0.95, 1.0, 0.85) * tint, true)
	draw_circle(Vector2(-width * 0.25, -10), 14.0, Color(1.0, 1.0, 1.0, 0.8) * tint)
	draw_circle(Vector2(width * 0.2, -10), 16.0, Color(1.0, 1.0, 1.0, 0.8) * tint)
