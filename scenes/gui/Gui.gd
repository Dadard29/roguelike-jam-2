extends CanvasLayer

onready var _lifebar = $TopLeft/Control/LifeBar
onready var _health_label = $TopLeft/Control/Health
onready var _seed_label = $TopRight/Control/Seed

func damaged(damage_taken: int, health_left: int) -> void:
	_lifebar.decrease_life(damage_taken)
	_health_label.set_text("Health: %d" % [health_left])
	
func set_seed(game_seed: int):
	_seed_label.set_text("Seed: %d" % game_seed)
	
