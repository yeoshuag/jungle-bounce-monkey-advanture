extends Area2D
class_name Player

signal jumped
signal died

const GRAVITY := 1600.0
const BASE_JUMP_FORCE := 820.0
const MAX_FALL_SPEED := 1400.0
const MOVE_LERP_SPEED := 10.0
const HALF_WIDTH := 32.0

@export var jump_power_multiplier: float = 1.0

var velocity: Vector2 = Vector2.ZERO
var target_x: float = 0.0
var is_dragging: bool = false
var alive: bool = true
var screen_width: float = 720.0

@onready var sprite: MonkeySprite = $MonkeySprite

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	target_x = position.x
	area_entered.connect(_on_area_entered)

func reset(start_y: float) -> void:
	alive = true
	is_dragging = false
	velocity = Vector2(0, -BASE_JUMP_FORCE)
	position = Vector2(screen_width / 2.0, start_y)
	target_x = position.x

func _physics_process(delta: float) -> void:
	if not alive:
		return
	velocity.y = min(velocity.y + GRAVITY * delta, MAX_FALL_SPEED)
	if is_dragging:
		position.x = lerp(position.x, target_x, clamp(MOVE_LERP_SPEED * delta, 0.0, 1.0))
	position += velocity * delta
	_wrap_screen()
	sprite.squash = clamp(1.0 + velocity.y / 3000.0, 0.75, 1.25)
	if position.y > _death_line():
		die()

func _death_line() -> float:
	var cam: Camera2D = get_viewport().get_camera_2d()
	if cam == null:
		return position.y - 1.0
	return cam.global_position.y + screen_width * 1.6

func _wrap_screen() -> void:
	if position.x < -HALF_WIDTH:
		position.x = screen_width + HALF_WIDTH
	elif position.x > screen_width + HALF_WIDTH:
		position.x = -HALF_WIDTH

func _unhandled_input(event: InputEvent) -> void:
	if not alive:
		return
	if event is InputEventScreenTouch:
		is_dragging = event.pressed
		target_x = event.position.x
	elif event is InputEventScreenDrag:
		is_dragging = true
		target_x = event.position.x
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.pressed
		target_x = event.position.x
	elif event is InputEventMouseMotion and is_dragging:
		target_x = event.position.x

func _on_area_entered(area: Area2D) -> void:
	if not alive:
		return
	if area.is_in_group("banana"):
		if area.has_method("collect"):
			area.collect()
		return
	if area.is_in_group("platform") and velocity.y > 0.0:
		if area.has_method("on_player_bounce"):
			var force: float = area.on_player_bounce(self)
			bounce(force)

func bounce(force: float) -> void:
	velocity.y = -force * jump_power_multiplier
	jumped.emit()

func die() -> void:
	if not alive:
		return
	alive = false
	died.emit()
