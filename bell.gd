extends Node2D

var enemy_scene = preload("res://enemy.tscn")

var wave_radius := 0.0

func _on_area_2d_area_entered(_area: Area2D) -> void:
	print("Ding!")
	ring()

func ring() -> void:
	var tw = create_tween()
	tw.tween_method(update_wave, 0.0, 1000.0, 1.0)

	for i in range(10):
		var inst = enemy_scene.instantiate()
		var angle = randf_range(0.0, PI * 2)
		var height = get_viewport_rect().size.y / 2.
		inst.global_position = global_position + Vector2(height, 0.0).rotated(angle)
		owner.add_child.call_deferred(inst)

func update_wave(radius: float) -> void:
	wave_radius = radius
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, get_viewport_rect().size.y / 2., Color.DARK_CYAN)
	if wave_radius > 0 and wave_radius < 1000.0:
		draw_arc(Vector2.ZERO, wave_radius, 0.0, PI * 2.0, floor(wave_radius / 2), Color.WHITE, 2.0, true)
