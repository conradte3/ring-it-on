extends MeshInstance3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("breathe"):
		jump()

func jump() -> void:
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "position:y", 2.0, 0.4).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "position:y", 1.0, 0.1).set_ease(Tween.EASE_IN)
	tw.tween_callback(splash)

func splash() -> void:
	$GPUParticles3D.restart()
