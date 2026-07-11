extends Area2D
class_name Player

signal jumped
signal died
signal shield_broken

const GRAVITY := 1600.0
const BASE_JUMP_FORCE := 820.0
const RESCUE_JUMP_FORCE := 1100.0
const MAX_FALL_SPEED := 1400.0
const HALF_WIDTH := 24.0
const MIN_MAGNET_SHAPE_RADIUS := 1.0
const DOUBLE_JUMP_FACTOR := 2.0
const ICE_SLIDE_SPEED_FACTOR := 0.35
const MOMENTUM_FACTOR := 1.0

@export var jump_power_multiplier: float = 1.0
@export var move_speed: float = 700.0

var velocity_y: float = 0.0
var target_x: float = 0.0
var is_dragging: bool = false
var alive: bool = true
var screen_width: float = 720.0
var shield_time_remaining: float = 0.0
var ice_slide_time_remaining: float = 0.0

@onready var sprite: MonkeySprite = $MonkeySprite
@onready var magnet_area: Area2D = $MagnetArea
@onready var magnet_shape: CircleShape2D = $MagnetArea/CollisionShape2D.shape

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	target_x = position.x
	area_entered.connect(_on_area_entered)
	magnet_area.area_entered.connect(_on_area_entered)

func reset(start_y: float) -> void:
	alive = true
	is_dragging = false
	jump_power_multiplier = UpgradeManager.get_jump_multiplier()
	velocity_y = -BASE_JUMP_FORCE
	position = Vector2(screen_width / 2.0, start_y)
	target_x = position.x
	var magnet_radius: float = UpgradeManager.get_magnet_radius()
	magnet_shape.radius = max(magnet_radius, MIN_MAGNET_SHAPE_RADIUS)
	magnet_area.monitoring = magnet_radius > 0.0
	shield_time_remaining = UpgradeManager.get_shield_duration()
	sprite.set_shielded(shield_time_remaining > 0.0)
	ice_slide_time_remaining = 0.0

func _physics_process(delta: float) -> void:
	if not alive:
		return
	velocity_y = min(velocity_y + GRAVITY * delta, MAX_FALL_SPEED)
	var effective_move_speed: float = move_speed
	if ice_slide_time_remaining > 0.0:
		effective_move_speed *= ICE_SLIDE_SPEED_FACTOR
	if is_dragging:
		position.x = move_toward(position.x, target_x, effective_move_speed * delta)
	position.x = clamp(position.x, HALF_WIDTH, screen_width - HALF_WIDTH)
	position.y += velocity_y * delta
	sprite.squash = clamp(1.0 + velocity_y / 3000.0, 0.75, 1.25)
	if shield_time_remaining > 0.0:
		shield_time_remaining = max(0.0, shield_time_remaining - delta)
		if shield_time_remaining <= 0.0:
			sprite.set_shielded(false)
	if ice_slide_time_remaining > 0.0:
		ice_slide_time_remaining = max(0.0, ice_slide_time_remaining - delta)
	if position.y > _death_line():
		die()

func _death_line() -> float:
	var cam: Camera2D = get_viewport().get_camera_2d()
	if cam == null:
		return position.y - 1.0
	return cam.global_position.y + screen_width * 1.6

func _unhandled_input(event: InputEvent) -> void:
	if not alive:
		return
	if event is InputEventScreenTouch:
		is_dragging = event.pressed
		target_x = clamp(event.position.x, HALF_WIDTH, screen_width - HALF_WIDTH)
	elif event is InputEventScreenDrag:
		is_dragging = true
		target_x = clamp(event.position.x, HALF_WIDTH, screen_width - HALF_WIDTH)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.pressed
		target_x = clamp(event.position.x, HALF_WIDTH, screen_width - HALF_WIDTH)
	elif event is InputEventMouseMotion and is_dragging:
		target_x = clamp(event.position.x, HALF_WIDTH, screen_width - HALF_WIDTH)

func _on_area_entered(area: Area2D) -> void:
	if not alive:
		return
	if area.is_in_group("banana"):
		if area.has_method("collect"):
			area.collect()
		return
	if area.is_in_group("powerup"):
		if area.has_method("collect"):
			area.collect(self)
		return
	if area.is_in_group("hazard"):
		die()
		return
	if area.is_in_group("platform") and velocity_y > 0.0:
		if area.has_method("on_player_bounce"):
			var force: float = area.on_player_bounce(self)
			bounce(force)

func bounce(force: float) -> void:
	var effective_force: float = max(force, velocity_y * MOMENTUM_FACTOR)
	var multiplier: float = jump_power_multiplier
	if GameManager.double_jump_time_remaining > 0.0:
		multiplier *= DOUBLE_JUMP_FACTOR
	velocity_y = -effective_force * multiplier
	jumped.emit()

func apply_shield(duration: float) -> void:
	shield_time_remaining = max(shield_time_remaining, duration)
	sprite.set_shielded(true)

func apply_ice_slide(duration: float) -> void:
	ice_slide_time_remaining = max(ice_slide_time_remaining, duration)

func die() -> void:
	if not alive:
		return
	if shield_time_remaining > 0.0:
		shield_time_remaining = 0.0
		sprite.set_shielded(false)
		velocity_y = -RESCUE_JUMP_FORCE
		position.y = _death_line() - 40.0
		shield_broken.emit()
		return
	alive = false
	died.emit()
