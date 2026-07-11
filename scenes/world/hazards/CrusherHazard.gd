extends Node2D
class_name CrusherHazard

enum State { RETRACTED, EXTENDING, CRUSHING, RETRACTING }

const EXTEND_TIME := 0.5
const CRUSH_HOLD_TIME := 0.4
const RETRACT_TIME := 0.6
const RETRACTED_HOLD_TIME := 1.2
const GAP_HALF_WIDTH := 70.0
const WALL_THICKNESS := 50.0

var active: bool = false
var state: int = State.RETRACTED
var state_time: float = 0.0
var screen_width: float = 720.0

@onready var left_wall: CrusherWallArm = $LeftWall
@onready var right_wall: CrusherWallArm = $RightWall

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	visible = false
	_set_wall_positions(0.0)

func activate(y: float) -> void:
	global_position = Vector2(0, y)
	visible = true
	active = true
	state = State.RETRACTED
	state_time = 0.0
	_set_wall_positions(0.0)
	left_wall.monitorable = true
	right_wall.monitorable = true
	left_wall.queue_redraw()
	right_wall.queue_redraw()

func deactivate() -> void:
	visible = false
	active = false
	left_wall.monitorable = false
	right_wall.monitorable = false

func _wall_x_extended(side: int) -> float:
	return screen_width / 2.0 + side * (GAP_HALF_WIDTH + WALL_THICKNESS / 2.0)

func _wall_x_retracted(side: int) -> float:
	if side < 0:
		return -WALL_THICKNESS
	return screen_width + WALL_THICKNESS

func _set_wall_positions(t: float) -> void:
	left_wall.position.x = lerp(_wall_x_retracted(-1), _wall_x_extended(-1), t)
	right_wall.position.x = lerp(_wall_x_retracted(1), _wall_x_extended(1), t)

func _process(delta: float) -> void:
	if not active:
		return
	state_time += delta
	match state:
		State.RETRACTED:
			if state_time >= RETRACTED_HOLD_TIME:
				state = State.EXTENDING
				state_time = 0.0
		State.EXTENDING:
			var t: float = clamp(state_time / EXTEND_TIME, 0.0, 1.0)
			_set_wall_positions(t)
			if t >= 1.0:
				state = State.CRUSHING
				state_time = 0.0
		State.CRUSHING:
			if state_time >= CRUSH_HOLD_TIME:
				state = State.RETRACTING
				state_time = 0.0
		State.RETRACTING:
			var t: float = clamp(state_time / RETRACT_TIME, 0.0, 1.0)
			_set_wall_positions(1.0 - t)
			if t >= 1.0:
				state = State.RETRACTED
				state_time = 0.0
