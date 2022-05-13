extends Node2D

onready var _tween = $Tween
onready var _animated = $AnimatedSprite
onready var _area = $Box/Shape
onready var _sound = $AudioUsed

export (String) var type = "DAMAGE"
export (int) var amount = 0

export (bool) var debug_activated_on_ready = false

func _ready():
	if debug_activated_on_ready:
		activate()

var _activated = true

signal deactivated

func set_stats(bonus_type: String, bonus_amount: int):
	self.type = bonus_type
	self.amount = bonus_amount
	
func deactivate():
	_activated = false
	_area.call_deferred("set_disabled", true)
	
	emit_signal("deactivated")
	
func is_activated():
	_sound.play()
	return _activated

func activate():
	_area.call_deferred("set_disabled", false)
	_animated.set_visible(true)
	_activated = true
	

func _on_Box_area_entered(area):
	if area.is_in_group("perso_body"):
		var initial = _animated.get_scale()
		var final = Vector2.ZERO
		_tween.interpolate_property(_animated, "scale", initial, final, 2, Tween.EASE_IN)
		_tween.start()
		yield(_tween, "tween_completed")
		queue_free()
