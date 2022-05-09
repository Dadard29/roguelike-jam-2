extends PlayerState

var _x_area_position = 37
onready var _collision = $Collision
onready var _sound = $Audio

var _swing_sound = preload("res://assets/sounds/swing.mp3")
var _hit_sound = preload("res://assets/sounds/hit.mp3")

func _on_animation_finished():
	if not player.animation.get_animation() == "attack":
		return
		
	_collision.disabled = true
		
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if player.is_jumping():
		state_machine.transition_to("Air", {jumping = true})
		return
	
	if player.is_moving():
		state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Idle")

func flip_horizontal(is_flipped) -> void:
	var new_position_x = _x_area_position
	if is_flipped:
		new_position_x = -_x_area_position
		
	self.position = Vector2(new_position_x, 0)

func enter(_msg := {}) -> void:
	player.update_animation("attack")
	_collision.disabled = false
	_sound.set_stream(_swing_sound)
	_sound.play()

func physic_update(delta: float):
	player.update_velocity(delta)

