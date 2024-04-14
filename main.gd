extends Node

func _on_player_died() -> void:
	$Control/GameOver.visible = true


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
