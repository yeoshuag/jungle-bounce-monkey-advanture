extends PlatformBase
class_name SecretPlatform

const REVEAL_FADE_TIME := 0.3

var revealed: bool = false
var reveal_timer: float = 0.0

@onready var reveal_area: Area2D = $RevealArea

func _ready() -> void:
	super._ready()
	reveal_area.area_entered.connect(_on_reveal_area_entered)

func activate(pos: Vector2, p_tint: Color = Color(1.0, 1.0, 1.0)) -> void:
	super.activate(pos, p_tint)
	revealed = false
	reveal_timer = 0.0
	modulate.a = 0.0
	reveal_area.monitoring = true

func deactivate() -> void:
	super.deactivate()
	reveal_area.monitoring = false

func _on_reveal_area_entered(area: Area2D) -> void:
	if area is Player:
		revealed = true

func _process(delta: float) -> void:
	if not active or not revealed or reveal_timer >= REVEAL_FADE_TIME:
		return
	reveal_timer += delta
	modulate.a = clamp(reveal_timer / REVEAL_FADE_TIME, 0.0, 1.0)

func _draw() -> void:
	draw_rect(Rect2(-width / 2.0, -10, width, 20), Color(0.55, 0.35, 0.65) * tint, true)
	draw_rect(Rect2(-width / 2.0, -10, width, 6), Color(0.75, 0.55, 0.85) * tint, true)
