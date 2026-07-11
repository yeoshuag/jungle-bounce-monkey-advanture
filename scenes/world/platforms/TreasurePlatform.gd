extends PlatformBase
class_name TreasurePlatform

const BREAK_DELAY := 0.4
const BONUS_BANANAS := 8

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
		GameManager.collect_banana(BONUS_BANANAS)
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
	var plank_color: Color = Color(0.75, 0.55, 0.3) if breaking else Color(0.55, 0.38, 0.2)
	draw_rect(Rect2(-width / 2.0, -10, width, 20), plank_color * tint, true)
	draw_rect(Rect2(-16, -30, 32, 20), Color(0.45, 0.28, 0.12) * tint, true)
	draw_rect(Rect2(-16, -30, 32, 6), Color(0.85, 0.7, 0.25) * tint, true)
	draw_rect(Rect2(-3, -30, 6, 20), Color(0.85, 0.7, 0.25) * tint, true)
