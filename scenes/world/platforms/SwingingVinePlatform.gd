extends PlatformBase
class_name SwingingVinePlatform

const VINE_LENGTH := 90.0
const SWING_AMPLITUDE := 0.9
const SWING_SPEED := 1.6

var anchor: Vector2 = Vector2.ZERO
var swing_time: float = 0.0

func activate(pos: Vector2, p_tint: Color = Color(1.0, 1.0, 1.0)) -> void:
	super.activate(pos, p_tint)
	anchor = pos - Vector2(0, VINE_LENGTH)
	swing_time = randf() * TAU

func _physics_process(delta: float) -> void:
	if not active:
		return
	swing_time += delta * SWING_SPEED
	var angle: float = sin(swing_time) * SWING_AMPLITUDE
	position = anchor + Vector2(sin(angle), cos(angle)) * VINE_LENGTH
	queue_redraw()

func on_player_bounce(_player: Node) -> float:
	return jump_force

func _draw() -> void:
	var vine_end: Vector2 = anchor - position
	draw_line(Vector2.ZERO, vine_end, Color(0.35, 0.25, 0.1) * tint, 4.0)
	draw_rect(Rect2(-width / 2.0, -10, width, 20), Color(0.4, 0.6, 0.25) * tint, true)
