extends Node2D

@export_range(50.0, 400.0) var speed := 200.0

var dash_mult := 1.0

var dash_start := Vector2.ZERO

var dash_duration := 0.2

var dir = Vector2.ZERO
var facing_dir = Vector2.RIGHT
var locked_dir = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		if dash_mult == 1.0:
			start_dash()

func start_dash():
	$Area2D/CollisionShape2D.disabled = false
	$Hurtbox/CollisionShape2D.disabled = true
	dash_start = global_position
	locked_dir = facing_dir
	var tw = create_tween()
	tw.tween_property(self, "dash_mult", 1.0, dash_duration) \
		.from(6.0) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_QUAD)
	tw.parallel().tween_method(update_line, 0.0, 1.0, dash_duration)
	tw.tween_callback(func():
		locked_dir = Vector2.ZERO
		$Area2D/CollisionShape2D.disabled = true
		$Hurtbox/CollisionShape2D.disabled = false
	)

func _process(delta: float) -> void:
	dir = Input.get_vector("left", "right", "up", "down")
	if dir != Vector2.ZERO:
		facing_dir = dir

	var cur_dir = dir
	if locked_dir != Vector2.ZERO:
		cur_dir = locked_dir
	position += cur_dir * speed * delta * dash_mult

	dash_mult = move_toward(dash_mult, 1.0, delta * 20.0)

func update_line(val: float) -> void:
	queue_redraw()

func _draw() -> void:
	if dash_mult > 1.0:
		var color = Color.BLACK
		draw_circle(Vector2.ZERO, 5.0, color)
		draw_line(dash_start - global_position, Vector2.ZERO, color, 10.0, true)
	else:
		draw_circle(Vector2.ZERO, 10.0, Color("d0f4f8"))


func _on_hurtbox_area_entered(area: Area2D) -> void:
	get_tree().reload_current_scene.call_deferred()
