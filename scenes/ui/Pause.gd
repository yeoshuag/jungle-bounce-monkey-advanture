extends Control
class_name PauseMenu

@onready var resume_button: Button = $VBox/ResumeButton
@onready var mute_button: Button = $VBox/MuteButton
@onready var menu_button: Button = $VBox/MenuButton

func _ready() -> void:
	visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	mute_button.pressed.connect(_on_mute_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	_refresh_mute_label()

func _refresh_mute_label() -> void:
	var muted: bool = SaveManager.data.settings.get("muted", false)
	mute_button.text = "Unmute" if muted else "Mute"

func _on_resume_pressed() -> void:
	AudioManager.play_button()
	var game: Node = get_tree().current_scene
	if game.has_method("toggle_pause"):
		game.toggle_pause()

func _on_menu_pressed() -> void:
	AudioManager.play_button()
	var game: Node = get_tree().current_scene
	if game.has_method("go_to_menu"):
		game.go_to_menu()

func _on_mute_pressed() -> void:
	var muted: bool = SaveManager.data.settings.get("muted", false)
	SaveManager.data.settings["muted"] = not muted
	SaveManager.save_game()
	AudioManager.play_button()
	_refresh_mute_label()
