extends HBoxContainer

onready var heart_1 = $Heart
onready var heart_2 = $Heart2
onready var heart_3 = $Heart3
onready var heart_4 = $Heart4

func _decrease_heart(heart: TextureProgress, damage: int) -> int:
	var heart_value = heart.value
	
	# heart already empty, returns full damage
	if heart_value == 0:
		return damage
	
	if heart_value <= damage:
		# heart killed
		# print("heart_killed: initial %s | current %s | damage %s" % [
#			heart_value, heart.value, damage
#		])
		heart.set_value(0)
		heart.set_visible(false)
		return damage - heart_value
	
	heart.set_value(heart_value - damage)
#	print("heart_damaged: initial %s | current %s | damage %s" % [
#		heart_value, heart.value, damage
#	])
	# no damage left to compute
	return 0
	

func decrease_life(damage_taken: int) -> void:
	var damage_left = damage_taken

	var hearts = [heart_4, heart_3, heart_2, heart_1]
	for heart in hearts:
		damage_left = _decrease_heart(heart, damage_left)
