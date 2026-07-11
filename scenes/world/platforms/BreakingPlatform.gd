extends PlatformBase
class_name BreakingPlatform

const BREAK_DELAY := 0.3

var breaking: bool = false
var break_timer: float = 0.0

func activate(pos: Vector2, p_tint: Color = Color(1.0, 1.0, 1.0)) -> void:
	super.activate(pos, p_tint)
	breaking = false
	break_timer = 0.0

func on_player_bounce(_player: Node) -> float:
	if not breaking:
		breaking = true
		break_timer = BREAK_DELAY
		AudioManager.play_break()
		queue_redraw()
	return jump_force

func _process(delta: float) -> void:
	if not active or not breaking:
		return
	break_timer -= delta
	if break_timer <= 0.0:
		deactivate()

func _draw() -> void:
	var color: Color = Color(0.75, 0.45, 0.25) if breaking else Color(0.55, 0.35, 0.2)
	var trim_color: Color = Color(0.85, 0.6, 0.4) if breaking else Color(0.68, 0.46, 0.3)
	draw_rect(Rect2(-width / 2.0, -10, width, 20), color * tint, true)
	draw_rect(Rect2(-width / 2.0, -10, width, 6), trim_color * tint, true)
	if breaking:
		draw_line(Vector2(-width * 0.2, -10), Vector2(-width * 0.1, 10), Color(0.25, 0.12, 0.05), 3.0)
		draw_line(Vector2(width * 0.15, -10), Vector2(width * 0.05, 10), Color(0.25, 0.12, 0.05), 3.0)
