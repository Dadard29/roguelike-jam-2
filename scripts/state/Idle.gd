extends PlayerState

func enter(_msg := {}) -> void:
	player.update_animation("idle")
	owner.velocity = Vector2.ZERO

func update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if player.is_jumping():
		state_machine.transition_to("Air", {jumping = true})
		return
	
	if player.is_moving():
		state_machine.transition_to("Run")
		return
		
	if player.is_attacking():
		state_machine.transition_to("Attack")
		return

		
	
	
