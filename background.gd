extends Node2D

func _draw() -> void:
	var size = get_viewport_rect().size
	#draw_rect(Rect2(Vector2.ZERO, size), Color("1c0820"))
	var half_size = size / 2.
	#Arena
	draw_circle(half_size, half_size.y - 8., Color("3c3468"))
