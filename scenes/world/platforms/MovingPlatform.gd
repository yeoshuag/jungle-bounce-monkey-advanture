extends PlatformBase
class_name MovingPlatform

@export var speed: float = 90.0

var direction: int = 1
var screen_width: float = 720.0

func _ready() -> void:
	super._ready()
	screen_width = get_viewport_rect().size.x

func activate(pos: Vector2) -> void:
	super.activate(pos)
	direction = 1 if randf() < 0.5 else -1

func _physics_process(delta: float) -> void:
	if not active:
		return
	var half_width: float = width / 2.0
	position.x += speed * direction * delta
	if position.x < half_width:
		position.x = half_width
		direction = 1
	elif position.x > screen_width - half_width:
		position.x = screen_width - half_width
		direction = -1

func _draw() -> void:
	draw_rect(Rect2(-width / 2.0, -10, width, 20), Color(0.85, 0.65, 0.15), true)
	draw_rect(Rect2(-width / 2.0, -10, width, 6), Color(0.95, 0.8, 0.3), true)
