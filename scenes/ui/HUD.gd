extends Control
class_name HUD

const BIOME_BANNER_DURATION := 2.5

@onready var altitude_label: Label = $VBox/AltitudeLabel
@onready var banana_label: Label = $VBox/BananaLabel
@onready var combo_label: Label = $VBox/ComboLabel
@onready var double_banana_label: Label = $VBox/DoubleBananaLabel
@onready var double_jump_label: Label = $VBox/DoubleJumpLabel
@onready var biome_banner: Label = $BiomeBanner
@onready var pause_button: Button = $PauseButton

var biome_banner_timer: float = 0.0

func _ready() -> void:
	GameManager.altitude_changed.connect(_on_altitude_changed)
	GameManager.banana_collected.connect(_on_banana_collected)
	GameManager.combo_changed.connect(_on_combo_changed)
	GameManager.combo_broken.connect(_on_combo_broken)
	GameManager.run_started.connect(_on_run_started)
	GameManager.double_banana_changed.connect(_on_double_banana_changed)
	GameManager.double_jump_changed.connect(_on_double_jump_changed)
	BiomeManager.biome_changed.connect(_on_biome_changed)
	pause_button.pressed.connect(_on_pause_pressed)
	_on_run_started()

func _process(delta: float) -> void:
	if biome_banner_timer > 0.0:
		biome_banner_timer -= delta
		if biome_banner_timer <= 0.0:
			biome_banner.text = ""

func _on_run_started() -> void:
	altitude_label.text = "0 m"
	banana_label.text = "Bananas: 0"
	combo_label.text = ""
	double_banana_label.text = ""
	double_jump_label.text = ""
	biome_banner.text = ""
	biome_banner_timer = 0.0

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

func _on_double_banana_changed(active: bool) -> void:
	double_banana_label.text = "2x BANANAS!" if active else ""

func _on_double_jump_changed(active: bool) -> void:
	double_jump_label.text = "2x JUMP!" if active else ""

func _on_biome_changed(biome_name: String) -> void:
	biome_banner.text = biome_name
	biome_banner_timer = BIOME_BANNER_DURATION

func _on_pause_pressed() -> void:
	AudioManager.play_button()
	var game: Node = get_tree().current_scene
	if game.has_method("toggle_pause"):
		game.toggle_pause()
