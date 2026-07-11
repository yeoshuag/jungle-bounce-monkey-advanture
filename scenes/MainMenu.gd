extends Control
class_name MainMenu

@onready var best_label: Label = $VBox/BestLabel
@onready var play_button: Button = $VBox/PlayButton
@onready var quit_button: Button = $VBox/QuitButton

func _ready() -> void:
	best_label.text = "Best: %d m" % int(SaveManager.data.best_altitude / 10.0)
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	AudioManager.play_button()
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_quit_pressed() -> void:
	AudioManager.play_button()
	get_tree().quit()
