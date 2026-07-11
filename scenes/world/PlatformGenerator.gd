extends Node2D
class_name PlatformGenerator

const NORMAL_SCENE: PackedScene = preload("res://scenes/world/platforms/NormalPlatform.tscn")
const MOVING_SCENE: PackedScene = preload("res://scenes/world/platforms/MovingPlatform.tscn")
const SPRING_SCENE: PackedScene = preload("res://scenes/world/platforms/SpringPlatform.tscn")
const BREAKING_SCENE: PackedScene = preload("res://scenes/world/platforms/BreakingPlatform.tscn")
const ICE_SCENE: PackedScene = preload("res://scenes/world/platforms/IcePlatform.tscn")
const STICKY_SCENE: PackedScene = preload("res://scenes/world/platforms/StickyPlatform.tscn")
const GOLDEN_SCENE: PackedScene = preload("res://scenes/world/platforms/GoldenPlatform.tscn")
const CLOUD_SCENE: PackedScene = preload("res://scenes/world/platforms/CloudPlatform.tscn")
const SECRET_SCENE: PackedScene = preload("res://scenes/world/platforms/SecretPlatform.tscn")
const TREASURE_SCENE: PackedScene = preload("res://scenes/world/platforms/TreasurePlatform.tscn")
const VINE_SCENE: PackedScene = preload("res://scenes/world/platforms/SwingingVinePlatform.tscn")
const BANANA_SCENE: PackedScene = preload("res://scenes/collectibles/Banana.tscn")
const DOUBLE_BANANA_SCENE: PackedScene = preload("res://scenes/collectibles/powerups/DoubleBananaPowerup.tscn")
const DOUBLE_JUMP_SCENE: PackedScene = preload("res://scenes/collectibles/powerups/DoubleJumpPowerup.tscn")
const SHIELD_SCENE: PackedScene = preload("res://scenes/collectibles/powerups/ShieldPowerup.tscn")
const CRUSHER_SCENE: PackedScene = preload("res://scenes/world/hazards/CrusherHazard.tscn")
const BEE_SCENE: PackedScene = preload("res://scenes/world/enemies/Bee.tscn")
const SNAKE_SCENE: PackedScene = preload("res://scenes/world/enemies/Snake.tscn")
const PARROT_SCENE: PackedScene = preload("res://scenes/world/enemies/Parrot.tscn")
const SPIRIT_SCENE: PackedScene = preload("res://scenes/world/enemies/JungleSpirit.tscn")

const MIN_GAP := 90.0
const MAX_GAP := 170.0
const NORMAL_POOL_SIZE := 10
const MOVING_POOL_SIZE := 10
const SPRING_POOL_SIZE := 6
const BREAKING_POOL_SIZE := 8
const ICE_POOL_SIZE := 6
const STICKY_POOL_SIZE := 6
const GOLDEN_POOL_SIZE := 3
const CLOUD_POOL_SIZE := 6
const SECRET_POOL_SIZE := 4
const TREASURE_POOL_SIZE := 2
const VINE_POOL_SIZE := 5
const BANANA_POOL_SIZE := 20
const POWERUP_POOL_SIZE_EACH := 4
const CRUSHER_POOL_SIZE := 3
const ENEMY_POOL_SIZE_EACH := 3
const BANANA_CHANCE := 0.45
const POWERUP_CHANCE := 0.05
const CRUSHER_CHANCE := 0.03
const CRUSHER_MIN_GAP := 900.0
const TREASURE_CHANCE := 0.015
const TREASURE_MIN_GAP := 1400.0
const ENEMY_CHANCE := 0.04
const INITIAL_ROWS := 10
const POWERUP_KEYS := ["double_banana", "double_jump", "shield"]

var camera: Camera2D
var highest_spawned_y: float = 0.0
var screen_width: float = 720.0
var last_crusher_y: float = 1000000.0
var last_treasure_y: float = 1000000.0

var pools: Dictionary = {}
var banana_pool: Array = []
var powerup_pools: Dictionary = {}
var crusher_pool: Array = []
var enemy_pools: Dictionary = {}
var active_platforms: Array = []
var active_bananas: Array = []
var active_powerups: Array = []
var active_crushers: Array = []
var active_enemies: Array = []

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	pools["normal"] = _build_pool(NORMAL_SCENE, NORMAL_POOL_SIZE)
	pools["moving"] = _build_pool(MOVING_SCENE, MOVING_POOL_SIZE)
	pools["spring"] = _build_pool(SPRING_SCENE, SPRING_POOL_SIZE)
	pools["breaking"] = _build_pool(BREAKING_SCENE, BREAKING_POOL_SIZE)
	pools["ice"] = _build_pool(ICE_SCENE, ICE_POOL_SIZE)
	pools["sticky"] = _build_pool(STICKY_SCENE, STICKY_POOL_SIZE)
	pools["golden"] = _build_pool(GOLDEN_SCENE, GOLDEN_POOL_SIZE)
	pools["cloud"] = _build_pool(CLOUD_SCENE, CLOUD_POOL_SIZE)
	pools["secret"] = _build_pool(SECRET_SCENE, SECRET_POOL_SIZE)
	pools["treasure"] = _build_pool(TREASURE_SCENE, TREASURE_POOL_SIZE)
	pools["vine"] = _build_pool(VINE_SCENE, VINE_POOL_SIZE)
	for i in range(BANANA_POOL_SIZE):
		var b: Banana = BANANA_SCENE.instantiate()
		add_child(b)
		banana_pool.append(b)
	powerup_pools["double_banana"] = _build_powerup_pool(DOUBLE_BANANA_SCENE, POWERUP_POOL_SIZE_EACH)
	powerup_pools["double_jump"] = _build_powerup_pool(DOUBLE_JUMP_SCENE, POWERUP_POOL_SIZE_EACH)
	powerup_pools["shield"] = _build_powerup_pool(SHIELD_SCENE, POWERUP_POOL_SIZE_EACH)
	for i in range(CRUSHER_POOL_SIZE):
		var c: CrusherHazard = CRUSHER_SCENE.instantiate()
		add_child(c)
		crusher_pool.append(c)
	enemy_pools["bee"] = _build_enemy_pool(BEE_SCENE, ENEMY_POOL_SIZE_EACH)
	enemy_pools["snake"] = _build_enemy_pool(SNAKE_SCENE, ENEMY_POOL_SIZE_EACH)
	enemy_pools["parrot"] = _build_enemy_pool(PARROT_SCENE, ENEMY_POOL_SIZE_EACH)
	enemy_pools["spirit"] = _build_enemy_pool(SPIRIT_SCENE, ENEMY_POOL_SIZE_EACH)

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

func _build_enemy_pool(scene: PackedScene, count: int) -> Array:
	var list: Array = []
	for i in range(count):
		var inst: EnemyBase = scene.instantiate()
		add_child(inst)
		list.append(inst)
	return list

func setup(start_camera: Camera2D, start_y: float) -> void:
	camera = start_camera
	highest_spawned_y = start_y
	last_crusher_y = 1000000.0
	last_treasure_y = 1000000.0
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
	for c: CrusherHazard in active_crushers:
		c.deactivate()
	active_crushers.clear()
	for e: EnemyBase in active_enemies:
		e.deactivate()
	active_enemies.clear()

func _spawn_initial(start_y: float) -> void:
	_spawn_starting_platform(start_y)
	var y: float = start_y
	for i in range(INITIAL_ROWS):
		y -= randf_range(MIN_GAP, MAX_GAP)
		_spawn_platform_row(y)
	highest_spawned_y = y

func _spawn_starting_platform(start_y: float) -> void:
	var plat: PlatformBase = _get_from_pool("normal")
	var tint: Color = BiomeManager.tint_for_altitude(-start_y)
	plat.activate(Vector2(screen_width / 2.0, start_y + 30.0), tint)
	active_platforms.append(plat)

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

func _get_crusher() -> CrusherHazard:
	for c: CrusherHazard in crusher_pool:
		if not c.active:
			return c
	return crusher_pool[0]

func _get_enemy(key: String) -> EnemyBase:
	for e: EnemyBase in enemy_pools[key]:
		if not e.active:
			return e
	return enemy_pools[key][0]

func _weighted_type(difficulty: float) -> String:
	var r: float = randf()
	var normal_w: float = lerp(0.42, 0.20, difficulty)
	var moving_w: float = lerp(0.12, 0.15, difficulty)
	var breaking_w: float = lerp(0.12, 0.18, difficulty)
	var spring_w: float = lerp(0.08, 0.11, difficulty)
	var ice_w: float = lerp(0.08, 0.10, difficulty)
	var sticky_w: float = lerp(0.06, 0.07, difficulty)
	var cloud_w: float = lerp(0.06, 0.07, difficulty)
	var golden_w: float = 0.03
	var secret_w: float = 0.02
	var ceiling: float = normal_w
	if r < ceiling:
		return "normal"
	ceiling += moving_w
	if r < ceiling:
		return "moving"
	ceiling += breaking_w
	if r < ceiling:
		return "breaking"
	ceiling += spring_w
	if r < ceiling:
		return "spring"
	ceiling += ice_w
	if r < ceiling:
		return "ice"
	ceiling += sticky_w
	if r < ceiling:
		return "sticky"
	ceiling += cloud_w
	if r < ceiling:
		return "cloud"
	ceiling += golden_w
	if r < ceiling:
		return "golden"
	ceiling += secret_w
	if r < ceiling:
		return "secret"
	return "vine"

func _spawn_platform_row(y: float) -> void:
	var alt: float = -y
	var difficulty: float = GameManager.difficulty_for_altitude(alt)
	var key: String = _weighted_type(difficulty)
	if last_treasure_y - y >= TREASURE_MIN_GAP and randf() < TREASURE_CHANCE:
		key = "treasure"
		last_treasure_y = y
	var plat: PlatformBase = _get_from_pool(key)
	var x: float = randf_range(90.0, screen_width - 90.0)
	var tint: Color = BiomeManager.tint_for_altitude(alt)
	plat.activate(Vector2(x, y), tint)
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
	if last_crusher_y - y >= CRUSHER_MIN_GAP and randf() < CRUSHER_CHANCE:
		var crusher: CrusherHazard = _get_crusher()
		crusher.activate(y - 300.0)
		active_crushers.append(crusher)
		last_crusher_y = y
	var eligible_enemies: Array = BiomeManager.enemies_for_altitude(alt)
	if eligible_enemies.size() > 0 and randf() < ENEMY_CHANCE:
		var enemy_key: String = eligible_enemies[randi() % eligible_enemies.size()]
		var enemy: EnemyBase = _get_enemy(enemy_key)
		var ex: float = randf_range(60.0, screen_width - 60.0)
		enemy.activate(Vector2(ex, y - 90.0))
		active_enemies.append(enemy)

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
	for c: CrusherHazard in active_crushers.duplicate():
		if not c.active or c.global_position.y > despawn_line:
			c.deactivate()
			active_crushers.erase(c)
	for e: EnemyBase in active_enemies.duplicate():
		if not e.active or e.global_position.y > despawn_line:
			e.deactivate()
			active_enemies.erase(e)
