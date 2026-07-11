extends Node

signal run_started
signal banana_collected(value: int, combo: int)
signal combo_changed(combo: int)
signal combo_broken
signal altitude_changed(altitude: float)

const COMBO_TIMEOUT := 2.5
const COMBO_MAX_MULTIPLIER := 5

var is_running: bool = false
var altitude: float = 0.0
var max_altitude_this_run: float = 0.0
var bananas_this_run: int = 0
var combo: int = 0
var combo_timer: float = 0.0

func _process(delta: float) -> void:
	if not is_running:
		return
	if combo > 0:
		combo_timer -= delta
		if combo_timer <= 0.0:
			combo = 0
			combo_broken.emit()

func start_run() -> void:
	is_running = true
	altitude = 0.0
	max_altitude_this_run = 0.0
	bananas_this_run = 0
	combo = 0
	combo_timer = 0.0
	run_started.emit()

func end_run() -> void:
	if not is_running:
		return
	is_running = false
	if max_altitude_this_run > SaveManager.data.best_altitude:
		SaveManager.data.best_altitude = max_altitude_this_run
	SaveManager.data.total_bananas += bananas_this_run
	SaveManager.save_game()

func report_altitude(new_altitude: float) -> void:
	altitude = new_altitude
	if altitude > max_altitude_this_run:
		max_altitude_this_run = altitude
		altitude_changed.emit(max_altitude_this_run)

func collect_banana(base_value: int = 1) -> void:
	combo += 1
	combo_timer = COMBO_TIMEOUT
	var multiplier: int = min(1 + combo / 5, COMBO_MAX_MULTIPLIER)
	var value: int = base_value * multiplier
	bananas_this_run += value
	banana_collected.emit(value, combo)
	combo_changed.emit(combo)

func difficulty_for_altitude(alt: float) -> float:
	return clamp(alt / 5000.0, 0.0, 1.0)
