extends PlayerState

var _x_area_position = 64
onready var _collision = $Collision

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

func _on_flipped_horizontal(is_flipped) -> void:
	var new_position_x = _x_area_position
	if is_flipped:
		new_position_x = -_x_area_position
		
	self.position = Vector2(new_position_x, 0)

func enter(_msg := {}) -> void:
	player.update_animation("attack")
	_collision.disabled = false

func physic_update(delta: float):
	player.update_velocity(delta)

