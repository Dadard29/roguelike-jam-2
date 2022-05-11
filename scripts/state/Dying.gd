extends PlayerState

func enter(_msg := {}) -> void:
	player.update_animation("die")
	owner.velocity = Vector2.ZERO

func update(_delta: float) -> void:
	pass

