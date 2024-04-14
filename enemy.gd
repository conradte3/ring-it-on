extends Node2D

var target: Node2D
var speed = 100.0

var avoiding: Array[Node2D] = [] as Array[Node2D]

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	var dir = (target.global_position - global_position).normalized()
	for avoid in avoiding:
		var diff = avoid.global_position - global_position
		var length = diff.length()
		var force = 5.0
		if length >= 1.0:
			force = force / length
		dir -= diff.normalized() * force

	position += dir.normalized() * speed * delta

func _draw() -> void:
	draw_circle(Vector2.ZERO, 10.0, Color.RED)


func _on_avoid_detector_area_entered(area: Area2D) -> void:
	avoiding.append(area)

func _on_avoid_detector_area_exited(area: Area2D) -> void:
	avoiding.erase(area)

func _on_body_area_area_entered(_area: Area2D) -> void:
	queue_free()
