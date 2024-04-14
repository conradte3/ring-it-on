extends Node2D


func _input(event: InputEvent) -> void:
	pass

func _process(delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up", "down")

