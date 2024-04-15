extends Node2D

signal ended(score, high_mult)

var score := 0.0 : set = set_score
var mult = 1 : set = set_mult
var meter = 0.0 : set = set_meter

var meter_delayed := 0.0 : set = set_meter_delayed

var buffer = 0.0

var high_mult := 1

func _draw() -> void:
	var size = get_viewport_rect().size
	var half_size = size / 2.

	var start_angle = -PI / 2.0
	var max_angle = PI * 2.
	var ratio = fmod(meter_delayed, 10.) / 10.0
	var angle = max_angle * ratio

	var width = min(floor(mult), 8.0)
	var base_radius = half_size.y - 8. + width / 4.
	draw_arc(half_size, base_radius, start_angle, start_angle + angle, 64, Color("d0f4f8"), width, true)
	#for i in range(mult):
		#if i == mult - 1:
			#draw_arc(half_size, base_radius + i, start_angle, start_angle + angle, 64, Color("d0f4f8"), 2.0, true)
		#else:
			#draw_arc(half_size, base_radius + i, 0.0, PI * 2., 64, Color("70b0c0"), 1.0, true)

func set_score(val: float) -> void:
	score = val
	$Score.text = "Score: %d\nx%d" % [score, mult]

func set_mult(val: int) -> void:
	mult = max(val, 1.0)
	high_mult = max(mult, high_mult)
	$Score.text = "Score: %d\nx%d" % [score, mult]

func set_meter(val: float) -> void:
	meter = max(val, 0.0)
	mult = 1 + meter / 10
	$ProgressBar.value = meter

func set_meter_delayed(val: float) -> void:
	var old = meter_delayed
	meter_delayed = val
	if meter_delayed != old:
		queue_redraw()

func _on_player_died() -> void:
	ended.emit(score, high_mult)

func _process(delta: float) -> void:
	if buffer > 0.0:
		buffer -= delta
	else:
		meter -= delta * 2.0
	meter_delayed = move_toward(meter_delayed, meter, delta * 10.0)

func _on_bell_rang() -> void:
	meter += 2.0
	buffer = 1.0

func _on_bell_enemy_died() -> void:
	score += 10.0 * mult
	meter += 0.5
	buffer = 1.0
