extends Node

const MAX_LEVEL := 5

const COST_PER_LEVEL := [150, 300, 550, 900, 1400]

const JUMP_MULTIPLIER_BY_LEVEL := [1.0, 1.05, 1.1, 1.15, 1.2, 1.3]
const MAGNET_RADIUS_BY_LEVEL := [0.0, 60.0, 90.0, 120.0, 150.0, 190.0]
const SHIELD_DURATION_BY_LEVEL := [0.0, 3.0, 4.5, 6.0, 8.0, 10.0]
const COMBO_TIMEOUT_BY_LEVEL := [2.5, 3.0, 3.5, 4.0, 4.5, 5.0]

func get_level(stat: String) -> int:
	return int(SaveManager.data.upgrades.get(stat, 0))

func cost_for_next_level(stat: String) -> int:
	var level: int = get_level(stat)
	if level >= MAX_LEVEL:
		return -1
	return COST_PER_LEVEL[level]

func can_purchase(stat: String) -> bool:
	var cost: int = cost_for_next_level(stat)
	return cost > 0 and SaveManager.data.total_bananas >= cost

func purchase(stat: String) -> bool:
	if not can_purchase(stat):
		return false
	var cost: int = cost_for_next_level(stat)
	SaveManager.data.total_bananas -= cost
	SaveManager.data.upgrades[stat] = get_level(stat) + 1
	SaveManager.save_game()
	return true

func get_jump_multiplier() -> float:
	return JUMP_MULTIPLIER_BY_LEVEL[get_level("jump_power")]

func get_magnet_radius() -> float:
	return MAGNET_RADIUS_BY_LEVEL[get_level("banana_collection")]

func get_shield_duration() -> float:
	return SHIELD_DURATION_BY_LEVEL[get_level("shield_duration")]

func get_combo_timeout() -> float:
	return COMBO_TIMEOUT_BY_LEVEL[get_level("combo_bonus")]
