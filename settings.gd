extends Panel

signal set_pause(should_pause: bool)

func _on_return_pressed() -> void:
	visible = false
	set_pause.emit(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = not visible
		set_pause.emit(visible)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), linear_to_db(value))


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	$HitSound.play()
