extends Node2D

var energy := 0.0 : set = set_energy

var breath = 1.0
var decay = 0.0
var velocity = Vector2.ZERO

var COST = 0.0
var SPEED = 50.0

var side = "Left"

func set_energy(new_val: float) -> void:
	energy = clamp(new_val, 0.0, 100.0)
	$ProgressBar.value = energy

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("breathe"):
		breath = 15.0
	
	for input in ["left", "right", "up", "down"]:
		if event.is_action_pressed(input):
			take_step(Input.get_vector("left", "right", "up", "down"))

func _process(delta: float) -> void:
	energy -= decay * delta
	energy += breath * delta
	breath = move_toward(breath, 0.0, delta * 10.0)
	
	position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, delta * 50.0)

func take_step(direction: Vector2) -> void:
	if energy < COST:
		return

	energy -= COST
	#velocity = SPEED * direction

	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", 1.2 * Vector2.ONE, 0.4).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(self, "global_position", global_position + direction * SPEED, 0.4).set_ease(Tween.EASE_IN)
	tw.tween_property(self, "scale", Vector2.ONE, 0.1).set_ease(Tween.EASE_IN)
	tw.tween_callback(splash)

func splash() -> void:
	pass
