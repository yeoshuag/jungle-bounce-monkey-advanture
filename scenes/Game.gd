extends Node2D
class_name Game

@onready var camera: Camera2D = $Camera2D
@onready var player: Player = $Player
@onready var platform_generator: PlatformGenerator = $PlatformGenerator
@onready var pause_menu: Control = $CanvasLayer/Pause
@onready var game_over_menu: GameOverMenu = $CanvasLayer/GameOver

var start_y: float = 0.0

func _ready() -> void:
	start_y = player.position.y
	camera.global_position = Vector2(get_viewport_rect().size.x / 2.0, start_y)
	pause_menu.visible = false
	game_over_menu.visible = false
	player.died.connect(_on_player_died)
	player.jumped.connect(_on_player_jumped)
	get_tree().paused = false
	_start_run()

func _start_run() -> void:
	player.reset(start_y)
	platform_generator.reset()
	platform_generator.setup(camera, start_y)
	camera.global_position = Vector2(get_viewport_rect().size.x / 2.0, start_y)
	GameManager.start_run()

func _physics_process(_delta: float) -> void:
	if not GameManager.is_running:
		return
	var target_y: float = min(camera.global_position.y, player.global_position.y)
	camera.global_position.y = lerp(camera.global_position.y, target_y, 0.15)
	GameManager.report_altitude(start_y - camera.global_position.y)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	if not GameManager.is_running:
		return
	pause_menu.visible = not pause_menu.visible
	get_tree().paused = pause_menu.visible

func _on_player_jumped() -> void:
	AudioManager.play_jump()

func _on_player_died() -> void:
	AudioManager.play_death()
	GameManager.end_run()
	get_tree().paused = true
	game_over_menu.show_results(GameManager.max_altitude_this_run, GameManager.bananas_this_run, SaveManager.data.best_altitude)

func restart() -> void:
	get_tree().paused = false
	game_over_menu.visible = false
	pause_menu.visible = false
	_start_run()

func go_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
