extends Control
class_name HUD

@onready var altitude_label: Label = $VBox/AltitudeLabel
@onready var banana_label: Label = $VBox/BananaLabel
@onready var combo_label: Label = $VBox/ComboLabel
@onready var pause_button: Button = $PauseButton

func _ready() -> void:
	GameManager.altitude_changed.connect(_on_altitude_changed)
	GameManager.banana_collected.connect(_on_banana_collected)
	GameManager.combo_changed.connect(_on_combo_changed)
	GameManager.combo_broken.connect(_on_combo_broken)
	GameManager.run_started.connect(_on_run_started)
	pause_button.pressed.connect(_on_pause_pressed)
	_on_run_started()

func _on_run_started() -> void:
	altitude_label.text = "0 m"
	banana_label.text = "Bananas: 0"
	combo_label.text = ""

func _on_altitude_changed(altitude: float) -> void:
	altitude_label.text = "%d m" % int(altitude / 10.0)

func _on_banana_collected(_value: int, _combo: int) -> void:
	banana_label.text = "Bananas: %d" % GameManager.bananas_this_run

func _on_combo_changed(combo: int) -> void:
	if combo >= 2:
		combo_label.text = "Combo x%d" % combo
	else:
		combo_label.text = ""

func _on_combo_broken() -> void:
	combo_label.text = ""

func _on_pause_pressed() -> void:
	AudioManager.play_button()
	var game: Node = get_tree().current_scene
	if game.has_method("toggle_pause"):
		game.toggle_pause()
