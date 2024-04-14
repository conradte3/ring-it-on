extends Node2D

@export_range(50.0, 400.0) var speed := 200.0

func _input(_event: InputEvent) -> void:
	pass
var size := Vector2.ZERO

func _process(delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	
	position += dir * speed * delta
	
	var old = size
	size = get_viewport_rect().size
	if old != size:
		print(size)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 10.0, Color.WHITE)
