extends Area2D
class_name PlatformBase

@export var jump_force: float = 820.0
@export var width: float = 140.0

var active: bool = false

func _ready() -> void:
	add_to_group("platform")
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

func on_player_bounce(_player: Node) -> float:
	return jump_force
