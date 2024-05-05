extends Node

var high_score = 0.0

var game_scene = preload("res://game.tscn")

var ending_game = false

var game = null

func _ready() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(0.5))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), linear_to_db(0.5))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not event is InputEventMouseButton:
		if $Control/MainMenu.visible:
			_on_start_pressed()
		if $Control/MarginContainer.visible and $Control/MarginContainer/GameOver/Restart.visible:
			_on_restart_pressed()

func _on_restart_pressed() -> void:
	$Control/MarginContainer/GameOver/Restart.visible = false
	var tw = create_tween()
	tw.tween_property($Control/MarginContainer, "modulate:a", 0.0, 0.5)
	tw.tween_callback(func():
		$Control/MarginContainer.visible = false
		start()
	)

func start() -> void:
	if game:
		printerr("There's still an active game")
		game.queue_free()

	game = game_scene.instantiate()
	game.ended.connect(_on_game_ended)
	add_child(game)

func _on_game_ended(score: float, high_mult: int) -> void:
	if ending_game:
		return

	ending_game = true
	$Control/MarginContainer.visible = true
	high_score = max(score, high_score)
	$Control/MarginContainer/GameOver/Score.text = "Highest Multiplier: x%d\nScore: %d\n\nHigh Score: %d" % [high_mult, score, high_score]

	var tw = create_tween()
	tw.tween_property($Control/MarginContainer, "modulate:a", 1.0, 1.0)
	tw.tween_callback(func():
		game.queue_free()
		game = null
	)
	tw.tween_callback(func():
		$Control/MarginContainer/GameOver/Restart.visible = true
		ending_game = false
	).set_delay(0.1)

func _on_start_pressed() -> void:
	var tw = create_tween()
	tw.tween_property($Control/MainMenu, "modulate:a", 0.0, 0.5)
	tw.tween_callback(func():
		$Control/MainMenu.visible = false
		start()
	)

func _on_settings_pressed() -> void:
	$Control/SettingsMenu.visible = true

func _on_settings_menu_set_pause(should_pause: bool) -> void:
	get_tree().paused = should_pause
