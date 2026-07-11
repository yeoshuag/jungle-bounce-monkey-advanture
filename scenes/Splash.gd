extends Control
class_name SplashScreen

const DISPLAY_TIME := 1.6

func _ready() -> void:
	await get_tree().create_timer(DISPLAY_TIME).timeout
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
