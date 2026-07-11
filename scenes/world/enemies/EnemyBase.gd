extends Area2D
class_name EnemyBase

var active: bool = false

func _ready() -> void:
	add_to_group("hazard")
	monitoring = false
	visible = false
	monitorable = false

func activate(pos: Vector2) -> void:
	global_position = pos
	visible = true
	active = true
	queue_redraw()
	set_deferred("monitorable", true)

func deactivate() -> void:
	visible = false
	active = false
	set_deferred("monitorable", false)
