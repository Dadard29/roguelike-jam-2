extends PlayerState

func enter(_msg := {}) -> void:
	player.update_animation("walk")

func physic_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	player.update_velocity(delta)
	
	if player.is_jumping():
		state_machine.transition_to("Air", {jumping = true})
		return
	
	if not player.is_moving():
		state_machine.transition_to("Idle")
		return
	
	if player.is_attacking():
		state_machine.transition_to("Attack")
		return
		
