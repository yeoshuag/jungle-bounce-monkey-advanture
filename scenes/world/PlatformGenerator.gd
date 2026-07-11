extends Node2D
class_name PlatformGenerator

const NORMAL_SCENE: PackedScene = preload("res://scenes/world/platforms/NormalPlatform.tscn")
const MOVING_SCENE: PackedScene = preload("res://scenes/world/platforms/MovingPlatform.tscn")
const SPRING_SCENE: PackedScene = preload("res://scenes/world/platforms/SpringPlatform.tscn")
const BANANA_SCENE: PackedScene = preload("res://scenes/collectibles/Banana.tscn")
const DOUBLE_BANANA_SCENE: PackedScene = preload("res://scenes/collectibles/powerups/DoubleBananaPowerup.tscn")
const DOUBLE_JUMP_SCENE: PackedScene = preload("res://scenes/collectibles/powerups/DoubleJumpPowerup.tscn")
const SHIELD_SCENE: PackedScene = preload("res://scenes/collectibles/powerups/ShieldPowerup.tscn")

const MIN_GAP := 90.0
const MAX_GAP := 170.0
const NORMAL_POOL_SIZE := 10
const MOVING_POOL_SIZE := 10
const SPRING_POOL_SIZE := 6
const BANANA_POOL_SIZE := 20
const POWERUP_POOL_SIZE_EACH := 4
const BANANA_CHANCE := 0.45
const POWERUP_CHANCE := 0.05
const INITIAL_ROWS := 10
const POWERUP_KEYS := ["double_banana", "double_jump", "shield"]

var camera: Camera2D
var highest_spawned_y: float = 0.0
var screen_width: float = 720.0

var pools: Dictionary = {}
var banana_pool: Array = []
var powerup_pools: Dictionary = {}
var active_platforms: Array = []
var active_bananas: Array = []
var active_powerups: Array = []

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	pools["normal"] = _build_pool(NORMAL_SCENE, NORMAL_POOL_SIZE)
	pools["moving"] = _build_pool(MOVING_SCENE, MOVING_POOL_SIZE)
	pools["spring"] = _build_pool(SPRING_SCENE, SPRING_POOL_SIZE)
	for i in range(BANANA_POOL_SIZE):
		var b: Banana = BANANA_SCENE.instantiate()
		add_child(b)
		banana_pool.append(b)
	powerup_pools["double_banana"] = _build_powerup_pool(DOUBLE_BANANA_SCENE, POWERUP_POOL_SIZE_EACH)
	powerup_pools["double_jump"] = _build_powerup_pool(DOUBLE_JUMP_SCENE, POWERUP_POOL_SIZE_EACH)
	powerup_pools["shield"] = _build_powerup_pool(SHIELD_SCENE, POWERUP_POOL_SIZE_EACH)

func _build_pool(scene: PackedScene, count: int) -> Array:
	var list: Array = []
	for i in range(count):
		var inst: PlatformBase = scene.instantiate()
		add_child(inst)
		list.append(inst)
	return list

func _build_powerup_pool(scene: PackedScene, count: int) -> Array:
	var list: Array = []
	for i in range(count):
		var inst: PowerupBase = scene.instantiate()
		add_child(inst)
		list.append(inst)
	return list

func setup(start_camera: Camera2D, start_y: float) -> void:
	camera = start_camera
	highest_spawned_y = start_y
	_spawn_initial(start_y)

func reset() -> void:
	for p: PlatformBase in active_platforms:
		p.deactivate()
	active_platforms.clear()
	for b: Banana in active_bananas:
		b.deactivate()
	active_bananas.clear()
	for p: PowerupBase in active_powerups:
		p.deactivate()
	active_powerups.clear()

func _spawn_initial(start_y: float) -> void:
	var y: float = start_y
	for i in range(INITIAL_ROWS):
		y -= randf_range(MIN_GAP, MAX_GAP)
		_spawn_platform_row(y)
	highest_spawned_y = y

func _get_from_pool(key: String) -> PlatformBase:
	for p: PlatformBase in pools[key]:
		if not p.active:
			return p
	return pools[key][0]

func _get_banana() -> Banana:
	for b: Banana in banana_pool:
		if not b.active:
			return b
	return banana_pool[0]

func _get_powerup(key: String) -> PowerupBase:
	for p: PowerupBase in powerup_pools[key]:
		if not p.active:
			return p
	return powerup_pools[key][0]

func _weighted_type(difficulty: float) -> String:
	var r: float = randf()
	var normal_ceiling: float = 0.65 - difficulty * 0.25
	var moving_ceiling: float = normal_ceiling + 0.2 + difficulty * 0.15
	if r < normal_ceiling:
		return "normal"
	elif r < moving_ceiling:
		return "moving"
	else:
		return "spring"

func _spawn_platform_row(y: float) -> void:
	var difficulty: float = GameManager.difficulty_for_altitude(-y)
	var key: String = _weighted_type(difficulty)
	var plat: PlatformBase = _get_from_pool(key)
	var x: float = randf_range(90.0, screen_width - 90.0)
	plat.activate(Vector2(x, y))
	active_platforms.append(plat)
	if randf() < POWERUP_CHANCE:
		var powerup_key: String = POWERUP_KEYS[randi() % POWERUP_KEYS.size()]
		var powerup: PowerupBase = _get_powerup(powerup_key)
		powerup.activate(Vector2(x, y - 46.0))
		active_powerups.append(powerup)
	elif randf() < BANANA_CHANCE:
		var banana: Banana = _get_banana()
		banana.activate(Vector2(x, y - 46.0))
		active_bananas.append(banana)

func _process(_delta: float) -> void:
	if camera == null:
		return
	var cam_y: float = camera.global_position.y
	var spawn_trigger_y: float = cam_y - screen_width * 1.2
	while highest_spawned_y > spawn_trigger_y:
		highest_spawned_y -= randf_range(MIN_GAP, MAX_GAP)
		_spawn_platform_row(highest_spawned_y)
	var despawn_line: float = cam_y + screen_width * 1.4
	for p: PlatformBase in active_platforms.duplicate():
		if p.global_position.y > despawn_line:
			p.deactivate()
			active_platforms.erase(p)
	for b: Banana in active_bananas.duplicate():
		if not b.active or b.global_position.y > despawn_line:
			active_bananas.erase(b)
	for p: PowerupBase in active_powerups.duplicate():
		if not p.active or p.global_position.y > despawn_line:
			active_powerups.erase(p)
