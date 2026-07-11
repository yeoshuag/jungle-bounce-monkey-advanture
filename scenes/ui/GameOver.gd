extends Control
class_name GameOverMenu

@onready var altitude_label: Label = $VBox/AltitudeLabel
@onready var bananas_label: Label = $VBox/BananasLabel
@onready var best_label: Label = $VBox/BestLabel
@onready var retry_button: Button = $VBox/RetryButton
@onready var menu_button: Button = $VBox/MenuButton

func _ready() -> void:
	visible = false
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func show_results(altitude: float, bananas: int, best: float) -> void:
	altitude_label.text = "Altitude: %d m" % int(altitude / 10.0)
	bananas_label.text = "Bananas: %d" % bananas
	best_label.text = "Best: %d m" % int(best / 10.0)
	visible = true

func _on_retry_pressed() -> void:
	AudioManager.play_button()
	var game: Node = get_tree().current_scene
	if game.has_method("restart"):
		game.restart()

func _on_menu_pressed() -> void:
	AudioManager.play_button()
	var game: Node = get_tree().current_scene
	if game.has_method("go_to_menu"):
		game.go_to_menu()
