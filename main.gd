extends Node

var high_score = 0.0

var game_scene = preload("res://game.tscn")

func _on_restart_pressed() -> void:
	$Control/GameOver.visible = false
	start()

func start() -> void:
	var game = game_scene.instantiate()
	game.ended.connect(_on_game_ended)
	add_child(game)

func _on_game_ended(score: float) -> void:
	high_score = max(score, high_score)
	$Control/GameOver/Score.text = "Score: %d\nHigh Score: %d" % [score, high_score]
	$Control/GameOver.visible = true
	$Game.queue_free()



func _on_start_pressed() -> void:
	$Control/MainMenu.visible = false
	start()
