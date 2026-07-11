extends Control
class_name UpgradesScreen

const STAT_LABELS := {
	"jump_power": "Jump Power",
	"banana_collection": "Banana Magnet",
	"shield_duration": "Shield Duration",
	"combo_bonus": "Combo Bonus",
}

@onready var banana_label: Label = $VBox/BananaLabel
@onready var back_button: Button = $VBox/BackButton
@onready var rows: Dictionary = {
	"jump_power": $VBox/RowJumpPower,
	"banana_collection": $VBox/RowBananaCollection,
	"shield_duration": $VBox/RowShieldDuration,
	"combo_bonus": $VBox/RowComboBonus,
}

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	for stat: String in rows.keys():
		var row: HBoxContainer = rows[stat]
		var button: Button = row.get_node("UpgradeButton")
		button.pressed.connect(_on_upgrade_pressed.bind(stat))
	_refresh()

func _refresh() -> void:
	banana_label.text = "Bananas: %d" % SaveManager.data.total_bananas
	for stat: String in rows.keys():
		var row: HBoxContainer = rows[stat]
		var name_label: Label = row.get_node("NameLabel")
		var level_label: Label = row.get_node("LevelLabel")
		var cost_label: Label = row.get_node("CostLabel")
		var button: Button = row.get_node("UpgradeButton")
		var level: int = UpgradeManager.get_level(stat)
		name_label.text = STAT_LABELS[stat]
		level_label.text = "Lv %d/%d" % [level, UpgradeManager.MAX_LEVEL]
		var cost: int = UpgradeManager.cost_for_next_level(stat)
		if cost < 0:
			cost_label.text = "MAX"
			button.disabled = true
			button.text = "MAX"
		else:
			cost_label.text = "%d" % cost
			button.disabled = not UpgradeManager.can_purchase(stat)
			button.text = "UPGRADE"

func _on_upgrade_pressed(stat: String) -> void:
	if UpgradeManager.purchase(stat):
		AudioManager.play_button()
		_refresh()

func _on_back_pressed() -> void:
	AudioManager.play_button()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
