extends Node2D

onready var _timer = $Timer

export (int) var speed = 10

var _direction = null

func _on_Timer_timeout():
	queue_free()
	
func _ready():
	pass
	
func fire(direction: Vector2):
	_direction = direction

func _process(_delta: float):
	if _direction == null:
		return
		
	self.global_translate(_direction * speed)
	self.rotate(PI/12)
	
