extends Node2D

onready var _animation = $Animation/Sprite
onready var _collision_box = $Area2D/CollisionShape2D
onready var _audio_hit = $AudioImpact
onready var _player = $Animation/Player

var dying: bool = false

func _die():
	_collision_box.call_deferred("set_disabled", true)
	_animation.play("die")
	yield(_animation, "animation_finished")
	self.queue_free()


func _update_shader(value):
	_animation.material.set_shader_param("flash_state", value)

func _take_damage():
	_audio_hit.play()
	_player.play("flash")
	
	# fixme
	_die()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("perso_attack"):
		_take_damage()
