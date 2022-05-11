extends Control

onready var velocity_label = $Container/Velocity
onready var state_label = $Container/State
onready var health_label = $Container/Health

func update_debug(velocity: Vector2, state_name: String, health: int):
	velocity_label.set_text("Velocity: {0}".format([velocity]))
	state_label.set_text("State: {0}".format([state_name]))
	health_label.set_text("Health: {0}".format([health]))

