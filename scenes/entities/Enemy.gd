extends Node2D

onready var _animation = $AnimatedSprite
onready var _collision = $Area2D

var dying: bool = false

func _die():
	dying = true
	_animation.play("die")
	yield(_animation, "animation_finished")
	self.queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("perso_attack"):
		_die()
