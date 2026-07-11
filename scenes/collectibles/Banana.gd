extends Area2D
class_name Banana

var active: bool = false
var bob_time: float = 0.0
var base_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("banana")
	monitoring = false
	visible = false
	monitorable = false

func activate(pos: Vector2) -> void:
	global_position = pos
	base_position = pos
	visible = true
	active = true
	bob_time = randf() * TAU
	queue_redraw()
	set_deferred("monitorable", true)

func deactivate() -> void:
	visible = false
	active = false
	set_deferred("monitorable", false)

func _process(delta: float) -> void:
	if not active:
		return
	bob_time += delta * 3.0
	position.y = base_position.y + sin(bob_time) * 6.0
	rotation = sin(bob_time * 0.5) * 0.15

func _draw() -> void:
	draw_arc(Vector2.ZERO, 12.0, PI * 0.15, PI * 1.65, 16, Color(0.98, 0.82, 0.15), 8.0, true)

func collect() -> void:
	if not active:
		return
	deactivate()
	GameManager.collect_banana(1)
	AudioManager.play_collect()
