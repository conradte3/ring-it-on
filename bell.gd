extends Node2D

var enemy_scene = preload("res://enemy.tscn")

var wave_radius := 0.0

signal enemy_died
signal rang

func _on_area_2d_area_entered(_area: Area2D) -> void:
	ring()

func ring() -> void:
	$AudioStreamPlayer.play()
	var tw = create_tween()
	tw.tween_method(update_wave, 0.0, 1000.0, 1.0)

	for i in range(10):
		var inst = enemy_scene.instantiate()
		var angle = randf_range(0.0, PI * 2)
		var height = get_viewport_rect().size.y / 2. - 4.
		inst.global_position = global_position + Vector2(height, 0.0).rotated(angle)
		inst.died.connect(func():
			enemy_died.emit()
		)
		owner.add_child.call_deferred(inst)
	
	rang.emit()

func update_wave(radius: float) -> void:
	wave_radius = radius
	queue_redraw()

func _draw() -> void:
	var color = Color("70b0c0")
	var color2 = Color("d0f4f8")
	
	#Sides
	draw_arc(Vector2(-46.0, -4.0), 24.0, 0.0, PI / 2.0, 10, color, 4.0, true)
	draw_arc(Vector2(46.0, -4.0), 24.0, PI / 2.0, PI, 10, color, 4.0, true)
	draw_arc(Vector2(0.0, -4.0), 22.0, 0.0, -PI, 20, color, 4.0, true)
	#Dinger
	draw_circle(Vector2(0.0, 20.0), 12.0, color2)
	#Bottom
	draw_line(Vector2(-46.0, 20.0), Vector2(46.0, 20.0), color, 4.0, true)
	draw_line(Vector2(-32.0, 16.0), Vector2(32.0, 16.0), color, 4.0, true)
	#draw_line(Vector2(-25.0, 12.0), Vector2(25.0, 12.0), color, 4.0, true)
	#draw_line(Vector2(-20.0, 8.0), Vector2(20.0, 8.0), color, 4.0, true)
	if wave_radius > 0 and wave_radius < 1000.0:
		draw_arc(Vector2.ZERO, wave_radius, 0.0, PI * 2.0, floor(wave_radius / 2), color, 2.0, true)
