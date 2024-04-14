extends Node2D

var target: Node2D
var speed = 90.0
var mult = 1.0

var radius = 12.0

var avoiding: Array[Node2D] = [] as Array[Node2D]

var time = 0.0
var threshold = 0.1

var last_dir = Vector2.ZERO

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	if randi() % 3 == 0:
		speed = 120.0
		radius = 7.0
		$BodyArea/CollisionShape2D.shape.radius = radius - 1.0

	threshold = randf_range(0.2, 0.5)

func _process(delta: float) -> void:
	time += delta
	if time > threshold:
		time -= threshold
		adjust_targeting()


	position += last_dir * speed * delta * mult

func adjust_targeting():
	var diff_to_target = target.global_position - global_position
	#var mult = 1.0
	#
	#if diff_to_target.length() < target.attack_radius:
		#mult = 0.6


	var dir = diff_to_target.normalized()
	for avoid in avoiding:
		var diff = avoid.global_position - global_position
		var length = diff.length()
		var force = 5.0
		if length >= 1.0:
			force = force / length
		dir -= diff.normalized() * force
	
	last_dir = dir.normalized()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color("70b0c0"))

func die() -> void:
	queue_free()

func _on_avoid_detector_area_entered(area: Area2D) -> void:
	avoiding.append(area)

func _on_avoid_detector_area_exited(area: Area2D) -> void:
	avoiding.erase(area)

func _on_body_area_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(13):
		mult = area.owner.slow
	else:
		die()

func _on_body_area_area_exited(area: Area2D) -> void:
	if area.get_collision_layer_value(13):
		mult = 1.0


