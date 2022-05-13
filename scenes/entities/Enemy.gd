class_name Enemy
extends Node2D

onready var _animation = $Animation/Sprite
onready var _collision_box = $Area2D/CollisionShape2D
onready var _audio_hit = $AudioImpact
onready var _player = $Animation/Player

signal dying

var _health: int = 15

func _die():
	emit_signal("dying")
	
	_collision_box.call_deferred("set_disabled", true)
	_animation.play("die")
	yield(_animation, "animation_finished")
	self.queue_free()


func _update_shader(value):
	_animation.material.set_shader_param("flash_state", value)

func _take_damage(damage: int):
	_audio_hit.play()
	_player.play("flash")
	
	
	_health -= damage
	if _health <= 0:
		_die()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("perso_attack"):
		var damage = area.get_parent().get_parent().attack_damage
		_take_damage(damage)
