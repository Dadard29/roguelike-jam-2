extends Node2D

onready var _bonus = $Bonus
onready var _tile_out = $Out

var _current_enemies_count = 0

func spawn_enemies(enemy_list: Array):
	var positions_node = get_node("EnemiesPosition")
	var enemies_node = get_node("Enemies")
	
	var index = 0
	for enemy_position in positions_node.get_children():
		var enemy = enemy_list[index]
		enemy.set_global_position(enemy_position.get_position())
		
		enemy.connect("dying", self, "enemy_died")
		
		enemies_node.add_child(enemy)
		index += 1
	
	_current_enemies_count = enemy_list.size()
	
	
func get_slot_count():
	var positions_node = get_node("EnemiesPosition")
	return positions_node.get_child_count()


func enemy_died():
	var bonus = get_node("Bonus")
	_current_enemies_count -= 1
	if _current_enemies_count == 0:
		bonus.activate()

func set_bonus(bonus_type: String, bonus_amount: int) -> void:
	var bonus = get_node("Bonus")
	bonus.set_stats(bonus_type, bonus_amount)
		
		

func _on_Bonus_deactivated():
	remove_child(_tile_out)
