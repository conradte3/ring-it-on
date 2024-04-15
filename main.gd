extends Node

var high_score = 0.0

var game_scene = preload("res://game.tscn")

var mute_music = false
var mute_sfx = false

func _on_restart_pressed() -> void:
	var tw = create_tween()
	tw.tween_property($Control/GameOver, "modulate:a", 0.0, 0.5)
	tw.tween_callback(func():
		$Control/GameOver.visible = false
		start()
	)


func start() -> void:
	var game = game_scene.instantiate()
	game.ended.connect(_on_game_ended)
	add_child(game)

var ending_game = false
func _on_game_ended(score: float, high_mult: int) -> void:
	if ending_game:
		return

	ending_game = true
	$Control/GameOver.visible = true
	high_score = max(score, high_score)
	$Control/GameOver/Score.text = "Highest Multiplier: x%d\nScore: %d\n\nHigh Score: %d" % [high_mult, score, high_score]

	var tw = create_tween()
	tw.tween_property($Control/GameOver, "modulate:a", 1.0, 1.0)
	tw.tween_callback(func():
		$Game.queue_free()
		ending_game = false
	)

func _on_start_pressed() -> void:
	var tw = create_tween()
	tw.tween_property($Control/MainMenu, "modulate:a", 0.0, 0.5)
	tw.tween_callback(func():
		$Control/MainMenu.visible = false
		start()
	)


func _on_music_pressed() -> void:
	mute_music = not mute_music
	AudioServer.set_bus_mute(1, mute_music)


func _on_sfx_pressed() -> void:
	mute_sfx = not mute_sfx
	AudioServer.set_bus_mute(2, mute_sfx)
