extends Node2D

signal ended(score)

var score := 0.0 : set = set_score
var mult = 1 : set = set_mult
var meter = 0.0 : set = set_meter

func set_score(val: float) -> void:
	score = val
	$Score.text = "Score: %d\nx%d" % [score, mult]

func set_mult(val: int) -> void:
	mult = max(val, 1.0)
	$Score.text = "Score: %d\nx%d" % [score, mult]

func set_meter(val: float) -> void:
	if val <= 0.0:
		if mult > 1:
			mult -= 1
			meter = 10.0
		else:
			meter = 0.0
	elif val >= 10.0:
		meter = 0.0
		mult += 1
	else:
		meter = val
	$ProgressBar.value = meter

func _on_player_died() -> void:
	ended.emit(score)

func _process(delta: float) -> void:
	meter -= delta

func _on_bell_rang() -> void:
	meter += 2

func _on_bell_enemy_died() -> void:
	score += 10.0
	meter += 1
