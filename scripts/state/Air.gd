extends PlayerState

func enter(msg := {}) -> void:
	player.update_animation("air")
	if msg.has("jumping") and msg.get("jumping") == true:
		player.jump()
	
	
func physic_update(delta: float) -> void:
	player.update_velocity(delta)
	
	if player.is_on_floor():
		if player.is_moving():
			state_machine.transition_to("Run")
		
		else:
			state_machine.transition_to("Idle")
	
	if player.is_attacking():
		state_machine.transition_to("Attack")
		return
