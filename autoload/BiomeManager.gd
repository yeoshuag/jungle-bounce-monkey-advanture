extends Node

signal biome_changed(biome_name: String)

const BIOMES := [
	{
		"name": "Jungle",
		"min_altitude": 0.0,
		"bg_color": Color(0.55, 0.85, 0.65),
		"platform_tint": Color(1.0, 1.0, 1.0),
		"enemies": ["bee", "snake"],
	},
	{
		"name": "Temple",
		"min_altitude": 3000.0,
		"bg_color": Color(0.75, 0.68, 0.45),
		"platform_tint": Color(0.85, 0.8, 0.65),
		"enemies": ["snake"],
	},
	{
		"name": "Volcano",
		"min_altitude": 6000.0,
		"bg_color": Color(0.35, 0.12, 0.1),
		"platform_tint": Color(0.75, 0.4, 0.32),
		"enemies": ["bee"],
	},
	{
		"name": "Night Forest",
		"min_altitude": 9000.0,
		"bg_color": Color(0.08, 0.08, 0.18),
		"platform_tint": Color(0.5, 0.52, 0.7),
		"enemies": ["spirit"],
	},
	{
		"name": "Cloud Kingdom",
		"min_altitude": 12000.0,
		"bg_color": Color(0.75, 0.85, 0.95),
		"platform_tint": Color(0.9, 0.92, 1.0),
		"enemies": ["parrot"],
	},
	{
		"name": "Space Jungle",
		"min_altitude": 15000.0,
		"bg_color": Color(0.05, 0.03, 0.15),
		"platform_tint": Color(0.75, 0.55, 0.95),
		"enemies": ["parrot", "spirit"],
	},
]

var current_index: int = 0
var current_bg_color: Color = BIOMES[0]["bg_color"]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func reset() -> void:
	current_index = 0
	current_bg_color = BIOMES[0]["bg_color"]
	RenderingServer.set_default_clear_color(current_bg_color)

func biome_index_for_altitude(altitude: float) -> int:
	var idx: int = 0
	for i in range(BIOMES.size()):
		if altitude >= BIOMES[i]["min_altitude"]:
			idx = i
	return idx

func tint_for_altitude(altitude: float) -> Color:
	return BIOMES[biome_index_for_altitude(altitude)]["platform_tint"]

func enemies_for_altitude(altitude: float) -> Array:
	return BIOMES[biome_index_for_altitude(altitude)]["enemies"]

func update_for_altitude(altitude: float) -> void:
	var new_index: int = biome_index_for_altitude(altitude)
	if new_index != current_index:
		current_index = new_index
		biome_changed.emit(BIOMES[current_index]["name"])
	var target_color: Color = BIOMES[current_index]["bg_color"]
	current_bg_color = current_bg_color.lerp(target_color, 0.02)
	RenderingServer.set_default_clear_color(current_bg_color)
