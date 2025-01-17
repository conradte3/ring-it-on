extends Node2D

@export_range(50.0, 400.0) var speed := 200.0

signal died

var attack_duration := 0.6

var dir = Vector2.ZERO
var facing_dir = Vector2.RIGHT
var locked_dir = Vector2.ZERO

var can_attack := true
var attack_radius := 0.01 : set = set_attack_radius
var attack_color = Color("1c0820")

var slow = 0.7

var move_freely = true

func set_attack_radius(val: float) -> void:
	attack_radius = val
	$Warner/CollisionShape2D.shape.radius = attack_radius
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if can_attack:
			attack()

var attack_tween: Tween

func attack():
	$ChargeSound.pitch_scale = randf_range(0.9, 1.1)
	$ChargeSound.play()
	can_attack = false
	move_freely = false

	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUAD)
	tw.set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "attack_radius", 64.0, attack_duration)
	tw.tween_callback(impact)
	tw.tween_callback(end_attack).set_delay(0.1)
	
	attack_tween = tw

func impact():
	$HitSound.pitch_scale = randf_range(0.8, 1.2)
	$HitSound.play()
	$Area2D/CollisionShape2D.disabled = false
	attack_color = Color("d0f4f8")
	queue_redraw()

func end_attack():
	move_freely = true
	$Area2D/CollisionShape2D.disabled = true
	attack_color = Color("70b0c0")
	var tw = create_tween()
	attack_tween = tw
	tw.set_ease(Tween.EASE_IN)
	tw.set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "attack_radius", 0.01, 0.4)
	tw.tween_callback(func():
		can_attack = true
		attack_color = Color("1c0820")
	)

var should_process = true
func _process(delta: float) -> void:
	if not should_process:
		return
	dir = Input.get_vector("left", "right", "up", "down")
	if dir != Vector2.ZERO:
		facing_dir = dir

	var mult = 1.0 if move_freely else 0.3
	var new_pos = global_position + dir * speed * delta * mult
	var center = get_viewport_rect().size / 2.
	if new_pos.distance_to(center) < center.y:
		global_position = new_pos


func _draw() -> void:
	if attack_radius > 0.01:
		draw_circle(Vector2.ZERO, attack_radius, attack_color)
	draw_circle(Vector2.ZERO, 10.0, Color("d0f4f8"))

func die() -> void:
	$DeadSound.play()
	attack_tween.kill()
	attack_radius = 0.01
	can_attack = false
	should_process = false
	attack_color = Color("1c0820")
	
	slow = 0.0
	var tw = create_tween()
	tw.tween_property(self, "attack_radius", get_viewport_rect().size.x / 2., 0.5)
	tw.tween_callback(finish_death)

func finish_death() -> void:
	died.emit()

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	die()
