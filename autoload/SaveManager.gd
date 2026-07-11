extends Node

const SAVE_PATH := "user://save.json"
const SAVE_VERSION := 1

var data: Dictionary = _default_data()

func _ready() -> void:
	load_game()

func _default_data() -> Dictionary:
	return {
		"version": SAVE_VERSION,
		"best_altitude": 0.0,
		"total_bananas": 0,
		"settings": {
			"music_volume": 0.8,
			"sfx_volume": 1.0,
			"muted": false,
		},
	}

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		data = _default_data()
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		data = _default_data()
		return
	var text := file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		data = _default_data()
		return
	var loaded: Dictionary = _default_data()
	for key: String in parsed.keys():
		loaded[key] = parsed[key]
	if typeof(loaded.get("settings")) != TYPE_DICTIONARY:
		loaded["settings"] = _default_data()["settings"]
	data = loaded

func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("SaveManager: could not open save file for writing")
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
