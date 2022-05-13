extends CanvasLayer

onready var _lifebar = $TopLeft/Control/LifeBar
onready var _health_label = $TopLeft/Control/Health
onready var _seed_label = $TopRight/Control/Seed
onready var _attack_label = $TopLeft/Control/Attack
onready var _armor_label = $TopLeft/Control/Armor

onready var _stream = $TopRight/Control/Music/Stream

func damaged(damage_taken: int, health_left: int) -> void:
	_lifebar.decrease_life(damage_taken)
	update_health(health_left)
	
func set_seed(game_seed: int):
	_seed_label.set_text("Seed: %d" % game_seed)

func reset_stats(base_health, base_attack, base_armor):
	for bar in _lifebar.get_children():
		bar.set_value(bar.get_max())
	
	update_attack(base_attack)
	update_armor(base_armor)
	update_health(base_health)


func _on_HSlider_value_changed(value):
	_stream.set_volume_db(value)
	
func update_health(health: int):
	_health_label.set_text("Health: %d" % [health])

func update_attack(attack_damage: int):
	_attack_label.set_text("Attack: %d" % attack_damage)

func update_armor(armor: int):
	_armor_label.set_text("Armor: %d" % armor)
